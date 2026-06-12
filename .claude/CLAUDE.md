# austin's claude config

Py: flask/polars/altair/sqlalchemy. `uv` + venv (`uv venv` if none). do not use global. imports go at the top unless there's a good reason not to.
Bio: onecodex/needletail (FASTX), onecodex/taxonomy for taxonomy.
Shell: miller (CSV), kuva (term plots).
Git: Linear branches; commits `[🤖] {msg}` 1-line; test pre-commit; draft PRs w/ `.github/PULL_REQUEST_TEMPLATE.md`, ASK first; NEVER comment-as-me or open issues.
For random bfx tasks, use the science-vessel Python environment: /Users/audy/Code/science-vessel/.venv/

## formatting preferences

when calling out to CLIs from python, group the argument name and value with a glob:

```python
check_output(['somecommand', *('--flag', str(value))])
```
