# austin's claude config

* Py: flask/polars/altair/sqlalchemy. `uv` + venv (`uv venv` if none). do not use global. imports go at the top unless there's a good reason not to. Do not use system python. Create a new venv if needed.
* Bio: onecodex/needletail (FASTX), onecodex/taxonomy for taxonomy. See `/taxonomy` skill for more.
* Shell: miller (CSV), kuva (term plots).
* Git: Linear branches; commits `[🤖] {msg}` 1-line; test pre-commit; draft PRs w/ `.github/PULL_REQUEST_TEMPLATE.md`, ASK first; NEVER comment-as-me or open issues.
* For random bfx tasks, use the science-vessel Python environment: /Users/audy/Code/science-vessel/.venv/

If I start a message with `Q:` that means I want you to only answer the question, not write any code.

## General Practices

* Try to keep PRs neat and focused, without straying off to fix unrelated TODOs or bugs or sneak in refactors. Solve the issue with the smallest possible diff. Code diff = review burden.
* When adding comments, add your name so I can distinguish between human- and agent-written comments. This does not include print statements

    ```python
    # yes
    # [claude] claude wrote this comment

    # no
    print("[claude] hello I am a print statement")
    ```

* Use markdown mermaid code-blocks for diagrams
* Don't `rm` files. Put them in the Trash/Recycle Bin

## Python

Conform to `ruff format`'s style even if it uses more tokens

When calling out to CLIs from python, group the argument name and value with a glob:

```python
check_output(['somecommand', *('--flag', str(value))])
```

Do not catch `Exception` and implement your own error reporting. Just let the exception bubble through. E.g., avoid patterns similar to this:

```python
try:
    some_code()
except Exception as e:
    hand_rolled_error_reporting()
```
