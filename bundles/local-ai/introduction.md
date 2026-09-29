# Local AI

llama.cpp, nvtop, and uv are installed. Ollama is not, because the right Ollama package depends on the GPU. Install → AI → Ollama makes that choice. LM Studio is Install → AI → LM Studio.

A project lives under `~/AI`. Create one with `omarchy bundle project new local-ai <name>`. The create script can offer the same Ollama install. uv runs the project's Python tools.

`llama-cli` is the llama.cpp command. `nvtop` shows GPU use in a terminal.

If you enabled the plugins, the bar can start a model that fits the GPU, show whether the Ollama server is running, control LM Studio, and show CPU, memory, and GPU load.
