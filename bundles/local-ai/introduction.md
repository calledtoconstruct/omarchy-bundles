# Local AI

This bundle is for running and building with local models. It installs three tools that are the same on every GPU, four bar plugins, and two agent skills. A project lives under `~/AI`.

Ollama is **not** in the package list. The right Ollama package depends on the GPU, and a bundle cannot say "install whichever one this machine needs." **Install → AI → Ollama** makes that choice:

| What the machine has | Package |
| --- | --- |
| `nvidia-smi` | `ollama-cuda` |
| `rocminfo` | `ollama-rocm` |
| anything else | `ollama` |

`ollama-vulkan` is also in the official repositories. The menu leaves it unselected. Removing Ollama later is `omarchy-remove-ai-ollama`, which drops all four names.

LM Studio is the same kind of choice. **Install → AI → LM Studio** installs the AUR package `lmstudio-bin`.

## What was installed

| Package | Command | What it is for |
| --- | --- | --- |
| `llama-cpp` | `llama-cli` | llama.cpp, beside Ollama |
| `nvtop` | `nvtop` | GPU use in a terminal for NVIDIA, AMD, and Intel |
| `uv` | `uv` | The project's Python tools, without a separate virtualenv step |

No AUR packages are installed by this bundle.

## A project

```
omarchy bundle project new local-ai my-model
```

The folder under `~/AI` holds a Modelfile, prompts, evals, a small Python client, and a compose file for Open WebUI. The create script can offer the same Ollama install the menu uses. Open WebUI is that compose service (`ghcr.io/open-webui/open-webui:main`), not an Arch package. Docker and Docker Compose are already on Omarchy.

`uv` runs `app/ask.py` and `evals/compare.py`.

## The bar

If you enabled the plugins:

- **Local AI** starts a model that fits the GPU, opens a coding agent on that model, and can share it on the tailnet.
- **Colophon** shows whether the Ollama server is running, and can start it, stop it, or load a model.
- **LM Studio** controls LM Studio from the bar. The application itself still comes from **Install → AI → LM Studio**.
- **Stats** shows CPU, memory, and GPU load. NVIDIA stays visible even when `nvidia-smi` is missing, and shows full stats when it works.

> Colophon is the one to look at when a model "is not there." It is the server, not the chat window.

## Skills

Two agent skills are linked where an agent skill directory already exists:

1. **ollama-models** for pulling and running a model.
2. **local-evals** for comparing answers from the project under `~/AI`.

Point the agent at that project and name the skill.
