---
name: local-evals
description: Keep local-model prompts and expected answers in evals/, run them against two Ollama models, and compare the answers in a markdown table.
---

# Local evals

Use this when comparing two models on a project created by the local-ai bundle. Cases live in the project. The comparison runs against the Ollama server at `http://127.0.0.1:11434`.

## Cases

`evals/cases.json` is a list of objects with `id`, `prompt`, and `expected`. Add a case by appending an object. Keep `expected` short enough to read in a table cell.

The create script writes one example, `capital`. Leave it in place so a later run still has a known row.

## Run

Both models have to be local already (`ollama list`). From the project root, with the server up:

```bash
uv run python evals/compare.py llama3.2:3b local
```

`evals/compare.py` is a stdlib script. It POSTs each prompt to `/api/generate` with `"stream": false`, once per model, and prints a markdown table:

| Case | Expected | model-a | model-b |
| --- | --- | --- | --- |
| capital | Paris | ... | ... |

Paste that table into the note for the comparison. The script does not pull weights and does not start Docker.

## Reading the table

A row matches when both answers carry the same fact as `expected`. Wording can differ. When one model misses, record the model name and the case id, then decide whether the Modelfile temperature, the context length, or the prompt is what you want to change. Re-run the same two names after that change so the tables stay comparable.
