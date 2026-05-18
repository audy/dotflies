---
name: taxonomy
description: Rust/Python library for reading, editing, and traversing biological taxonomies. Supports NCBI, JSON, Newick, GTDB, and PhyloXML formats.
license: MIT
metadata:
  author: One Codex
  source: https://github.com/onecodex/taxonomy
---

# taxonomy skill

Rust library with Python bindings (`pyo3`/`maturin`) for reading, editing, and traversing biological taxonomies. Supports NCBI, JSON, Newick, GTDB, and PhyloXML formats.

## Setup

```python
from taxonomy import Taxonomy
```

Build with `maturin develop` (activate `.venv` first: `source .venv/bin/activate`).

## Loading taxonomies

Austin keeps NCBI taxdumps in `~/science`. Preferred load path:

```python
tax = Taxonomy.from_ncbi("~/science/taxdump")  # nodes.dmp + names.dmp
tax = Taxonomy.from_json(open("tax.json").read())  # auto-detects tree vs node_link format
tax = Taxonomy.from_newick("(A:0.1,B:0.2)root;")
tax = Taxonomy.from_gtdb(open("bac120_taxonomy.tsv").read())  # experimental
```

JSON supports an optional pointer for nested data: `Taxonomy.from_json(s, json_pointer="/data/taxonomy")`.

## Node lookup

```python
node = tax["562"]           # raises if missing
node = tax.node("562")      # returns None if missing
"562" in tax                # membership test

node.id        # str (even for NCBI integer IDs)
node.name      # scientific name
node.rank      # "species", "genus", etc.
node.parent    # parent tax_id str, or None for root
node["readcount"]  # extra fields from JSON data
```

## Traversal

```python
tax.parent("562")                    # immediate parent TaxonomyNode
tax.parent("562", at_rank="genus")   # first ancestor at that rank (or None)
tax.parent_with_distance("562")      # (TaxonomyNode, float) tuple

tax.children("562")       # direct children
tax.descendants("562")    # all descendants (recursive)
tax.lineage("562")        # [self, ..., root] inclusive
tax.parents("562")        # [parent, ..., root] excludes self

tax.lca("562", "585")     # lowest common ancestor

tax.find_all_by_name("Escherichia")  # list of TaxonomyNode

for tax_id in tax:        # preorder traversal of all IDs
    ...
len(tax)                  # total node count
```

## Editing

Edits are **in-place**. `prune()` returns a new object.

```python
tax.add_node(parent_id, tax_id, name, rank)   # raises if tax_id exists
tax.edit_node(tax_id, name=None, rank=None, parent_id=None, parent_distance=None)
tax.remove_node(tax_id)   # children reattached to parent; root forbidden
del tax[tax_id]           # same as remove_node
```

## Pruning (returns new Taxonomy)

```python
subtree = tax.prune(keep=["562", "585"])   # keep nodes + all their ancestors
pruned  = tax.prune(remove=["1236"])       # remove node + all descendants
both    = tax.prune(keep=[...], remove=[...])  # keep applied first
```

## Exporting

```python
tax.to_json_tree()        # bytes, nested tree format
tax.to_json_node_links()  # bytes, node-link format
tax.to_newick()           # bytes
tax.to_ncbi("output_dir") # writes nodes.dmp + names.dmp
tax.clone()               # deep copy
```

## Taxonomy Time Machine API

`https://taxonomy.onecodex.com` — tracks NCBI taxonomy history back to 2014. Useful for resolving merged, deleted, or renamed tax IDs.

```python
import httpx

BASE = "https://taxonomy.onecodex.com"

# Look up all events for a tax ID (merges, renames, deletions)
resp = httpx.get(f"{BASE}/api/events", params={"tax_id": "562"})
events = resp.json()
# each event: {tax_id, name, rank, parent_id, event_name, version_date, merged_into_id}

# Get lineage at a point in time
resp = httpx.get(f"{BASE}/api/lineage", params={"tax_id": "562", "version_date": "2020-01-01"})

# Find what a merged ID was merged into
for e in events:
    if e["merged_into_id"]:
        print(f"{e['tax_id']} merged into {e['merged_into_id']} on {e['version_date']}")

# Search by name or partial tax ID
resp = httpx.get(f"{BASE}/api/search", params={"query": "Escherichia"})

# Children at a historical date
resp = httpx.get(f"{BASE}/api/children", params={"tax_id": "561", "version_date": "2019-06-01"})
```

## Common patterns

```python
# Resolve a list of (possibly stale) tax IDs against current taxonomy
def resolve(tax_id, tax):
    if tax_id in tax:
        return tax_id
    events = httpx.get(f"{BASE}/api/events", params={"tax_id": tax_id}).json()
    for e in sorted(events, key=lambda e: e["version_date"], reverse=True):
        if e["merged_into_id"] and e["merged_into_id"] in tax:
            return e["merged_into_id"]
    return None

# Collapse reads to genus level
def to_genus(tax_id, tax):
    node = tax.parent(tax_id, at_rank="genus")
    return node.id if node else None

# Filter taxonomy to a clade
bacteria = tax.prune(keep=tax.children("2"))  # keep Bacteria + parents
```

## Notes

- All tax IDs are strings internally (NCBI integers → `"562"`).
- `TaxonomyError` for expected errors; `pyo3_runtime.PanicException` = Rust bug, file an issue.
- Rank strings match NCBI conventions: `"species"`, `"genus"`, `"no rank"`, `"synthetic"`, etc.
- Branch distances default to `1.0` for formats that don't encode them (NCBI, JSON).
