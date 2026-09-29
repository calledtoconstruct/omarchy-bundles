# Local AI

For people running and building with local models on Omarchy. One install adds llama.cpp, a GPU monitor in the terminal, and uv, plus four bar plugins and two agent skills. A new project under `~/AI` holds the Modelfile, prompts, evals, a small Python client, and a compose file for Open WebUI. The install notification opens `introduction.md`.

This bundle is the example of a GPU-specific install choice. Ollama's four official packages cannot be installed together, and `bundle.json` cannot say "install whichever one the GPU needs". Those packages stay out of `packages`. The create script offers the menu action that already makes the choice.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `llama-cpp` | extra | `llama-cli` and the rest of the llama.cpp tools, beside Ollama |
| `nvtop` | extra | Terminal GPU usage for NVIDIA, AMD, and Intel |
| `uv` | extra | Runs `app/ask.py` and `evals/compare.py` with a stdlib-only project |

No AUR packages.

Ollama is an Omarchy installer, not a line in `packages`. Install → AI → Ollama (`install.ai.ollama`) does this, and the create script offers the same command:

```bash
if omarchy-cmd-present nvidia-smi; then ollama_pkg=ollama-cuda
elif omarchy-cmd-present rocminfo; then ollama_pkg=ollama-rocm
else ollama_pkg=ollama
fi
omarchy-install-app Ollama "$ollama_pkg"
```

`omarchy-install-app` is the command that menu item runs. The four packages are `ollama`, `ollama-cuda`, `ollama-rocm`, and `ollama-vulkan`, all in extra at the same upstream version. `ollama-vulkan` is the one the menu branch leaves unselected. Removing Ollama later is `omarchy-remove-ai-ollama`, which drops all four names.

LM Studio is also a menu install, not a package in this bundle. Install → AI → LM Studio runs `omarchy-install-app 'LM Studio' lmstudio-bin`. The AUR package is `lmstudio-bin`.

Open WebUI is a compose service in the project, image `ghcr.io/open-webui/open-webui:main`. The AUR package `open-webui` 0.11.3-1 is flagged out of date, so this bundle does not install it. Docker and Docker Compose are already in Omarchy's base packages.

## Plugins

Each URL was checked against `omarchy-plugin-validate`. The schema cannot store a commit, so the reviewed revisions are written here. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

| Plugin | Id | Reviewed commit | What it adds |
| --- | --- | --- | --- |
| [0xSero/omarchy-local-ai](https://github.com/0xSero/omarchy-local-ai) | `sero.local-ai` | `ec2fae389b24b1ef505bb08fdb43106b4e1d4f27` | A bar button for a model that fits the GPU. It starts the server, opens a coding agent on that model, and can share it on the tailnet |
| [ssandys/colophon](https://github.com/ssandys/colophon) | `ssandys.colophon` | `50f4dc516b756d0dfbbd5ee2ac66fcd736146acb` | Whether the Ollama server is running, start or stop it, and load a model |
| [25cent9/omarchy-lmstudio-plugin](https://github.com/25cent9/omarchy-lmstudio-plugin) | `io.github.25cent9.lmstudio` | `d44e8e82b2130061bc88bd9c6f514ec07788fd12` | LM Studio controls in the bar. LM Studio itself comes from Install → AI → LM Studio |
| [crmne/omastats](https://github.com/crmne/omastats) | `crmne.omastats` | `32538d0e4fd6348cda66782207e92c883d962fbf` | CPU, memory, and GPU in the bar. NVIDIA stays visible even when `nvidia-smi` is missing, and shows full stats when it works. AMD amdgpu reports load, clock, power, and temperature. Reading an awake AMD card restarts its runtime-suspend timer, about six seconds. Intel i915/xe reports clock and temperature, and the driver publishes no utilization counter in sysfs |

`LinuxGamerUK/omarchy-ollama-status` was requested and the GitHub repository returns 404, so it is not listed. Colophon is the Ollama status widget in its place. It overlaps 0xSero's plugin on starting the server. Both stay. 0xSero's plugin is the GPU-validated model button and the handoff to an agent or the tailnet. Colophon is the service switch and the loaded-model list.

`nvtop`, from extra, is the full-screen terminal monitor. OmaStats is the bar readout for the same machines.

## Project layout

`omarchy bundle project new local-ai <name>` creates `~/AI/<name>/{models,prompts,evals,app,data}` and `.omarchy-project`, then shows `scripts/create-project.sh` and asks before running it.

The script is safe to run again. It writes a file only when that file is missing.

1. If `ollama` is missing, it explains the four-package split and offers `omarchy-install-app` with the menu's GPU branch. Declining leaves Ollama uninstalled and continues.
2. It copies `models/Modelfile` and `prompts/system.md` from `scripts/templates/`.
3. It writes a uv project at the project root (`pyproject.toml`, no third-party dependencies) and `app/ask.py`, which POSTs to `http://127.0.0.1:11434/api/generate`.
4. It writes `compose.yaml`. Open WebUI uses `OLLAMA_BASE_URL=http://host.docker.internal:11434` and `extra_hosts: host.docker.internal:host-gateway`. Data is `./data/open-webui`. The script does not run `docker compose`.
5. It prints the suggested pull, `llama3.2:3b` at 2.0 GB, and asks before `ollama pull`. With no Ollama on `PATH`, it skips the pull. It does not run `ollama create`. That command is printed for you to run after the weights are local.

Without a terminal, every confirm is treated as no. The script still writes the project files, explains the missing Ollama install, and exits 0. It does not call `omarchy-install-app`, `ollama pull`, Docker, or uv.

## Launcher

There is no launcher field in `bundle.json`. This is the flow to use after a project exists. A Quickshell button for it is later work.

1. Open a terminal in the project. `ollama run local` talks to the named model. `uv run python app/ask.py` sends one prompt to `localhost:11434`. The model name defaults to `llama3.2:3b`. Set `OLLAMA_MODEL` after `ollama create`.
2. Open Open WebUI in the browser at `http://127.0.0.1:8080` after `docker compose up`. The first start pulls `ghcr.io/open-webui/open-webui:main`.
3. Open `nvtop` for GPU use. The OmaStats bar plugin is the same picture while you stay in other windows.
4. Edit `prompts/system.md` and `evals/cases.json`. Compare two local models with `uv run python evals/compare.py <model-a> <model-b>`.

## Conflicts

None with other bundles. The package conflict this bundle cares about is inside Ollama's own packages, and it is handled by leaving them out of `packages`. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).
