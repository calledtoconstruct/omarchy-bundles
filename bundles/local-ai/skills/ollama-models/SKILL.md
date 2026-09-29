---
name: ollama-models
description: Pick a local Ollama model that fits this machine, pull it, write a Modelfile, and create a named model.
---

# Ollama models

Use this when choosing or customizing a model for a project created by the local-ai bundle. The project root holds `models/Modelfile` and `prompts/system.md`.

The steps below are original. Two public skills were the model for the workflow, and their text is not copied here:

- [sickn33/agentic-awesome-skills, skill ollama-stack](https://github.com/sickn33/agentic-awesome-skills/blob/main/skills/ollama-stack/SKILL.md), for running Ollama with a local UI and hardware-aware choices
- [anubhavg-icpl/vibe, skill ollama-modelfile-expert](https://github.com/anubhavg-icpl/vibe/blob/master/skills/ollama-modelfile-expert/SKILL.md), for Modelfile instructions

## Fit the machine

Read memory before choosing a tag.

- GPU memory: `nvidia-smi`, `rocm-smi`, or the GPU tab in the OmaStats plugin.
- System RAM: `free -h`.

A machine with 8 GB of memory can run `llama3.2:3b`. That tag is Q4_K_M and the library lists it at 2.0 GB: https://ollama.com/library/llama3.2:3b. For a smaller GPU, look up `llama3.2:1b` on the same library page and use the size printed there. For a larger GPU, pick a bigger tag only after you have read its size. Say the size out loud before any pull.

## Pull

Ask, then pull the one tag you chose:

```bash
ollama pull llama3.2:3b
```

`ollama pull` downloads the weights. Skip it when the tag is already local (`ollama list`).

## Modelfile

Keep the system prompt in `prompts/system.md`. Write `models/Modelfile` with these instructions:

- `FROM` is the tag you pulled.
- `PARAMETER temperature` is the sampling temperature. `0.2` stays close to the prompt. Raise it when the task wants variation.
- `PARAMETER num_ctx` is the context length in tokens. `4096` is a workable start on an 8 GB machine. A longer context uses more memory.
- `SYSTEM` is the text from `prompts/system.md`, in a triple-quoted block.

Official instruction reference: https://github.com/ollama/ollama/blob/main/docs/modelfile.mdx

## Named model

From the project root:

```bash
ollama create local -f models/Modelfile
ollama run local
```

`local` is the name for this project. Use another name when the project has more than one Modelfile, and pass that name as `OLLAMA_MODEL` to `app/ask.py`.
