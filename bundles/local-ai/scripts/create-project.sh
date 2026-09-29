#!/bin/bash

# Runs only from `omarchy bundle project new`, after that command has shown
# this file and you have confirmed. Safe to run again. It does not pull a
# model, an image, or an Ollama package unless you confirm.

set -euo pipefail

project_dir=${PROJECT_DIR:-$PWD}
bundle_dir=${BUNDLE_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
cd -- "$project_dir"

ask() {
  local prompt="$1"
  if [[ -t 0 && -t 1 ]]; then
    gum confirm "$prompt"
    return
  fi
  return 1
}

copy_once() {
  local src="$1" dest="$2"
  if [[ -e $dest ]]; then
    return
  fi
  mkdir -p -- "$(dirname -- "$dest")"
  cp -- "$src" "$dest"
}

template="$bundle_dir/scripts/templates"

if ! command -v ollama >/dev/null 2>&1; then
  cat <<'EOF'
Ollama is not on PATH.
The official packages ollama, ollama-cuda, ollama-rocm, and ollama-vulkan cannot be installed together.
Install → AI → Ollama (menu id install.ai.ollama) chooses one package and passes it to omarchy-install-app:
  nvidia-smi present, then ollama-cuda
  otherwise rocminfo present, then ollama-rocm
  otherwise ollama
ollama-vulkan stays out of that menu branch. The command the menu runs is omarchy-install-app.
EOF
  if ask "Run Install → AI → Ollama now? It installs one Ollama package."; then
    if omarchy-cmd-present nvidia-smi; then
      ollama_pkg=ollama-cuda
    elif omarchy-cmd-present rocminfo; then
      ollama_pkg=ollama-rocm
    else
      ollama_pkg=ollama
    fi
    omarchy-install-app Ollama "$ollama_pkg"
  else
    echo "Left Ollama uninstalled. Use Install → AI → Ollama when you want the package for this GPU."
  fi
fi

mkdir -p -- models prompts evals app data
copy_once "$template/Modelfile" models/Modelfile
copy_once "$template/system.md" prompts/system.md
copy_once "$template/ask.py" app/ask.py
copy_once "$template/pyproject.toml" pyproject.toml
copy_once "$template/compare.py" evals/compare.py
copy_once "$template/cases.json" evals/cases.json
copy_once "$template/compose.yaml" compose.yaml
copy_once "$template/gitignore" .gitignore

model=llama3.2:3b
size="2.0 GB"
echo "Suggested model for a machine with 8 GB: ${model} (${size}, Q4_K_M). Size from https://ollama.com/library/llama3.2:3b."
if command -v ollama >/dev/null 2>&1; then
  if ask "Pull ${model} (${size})?"; then
    ollama pull "$model"
  else
    echo "Skipped ollama pull ${model}."
  fi
else
  echo "Skipped the model pull because Ollama is not installed."
fi

echo "When the weights are local, create the named model with: ollama create local -f models/Modelfile"
echo "Open WebUI is compose.yaml. Start it yourself with docker compose up. This script does not pull the image."
printf 'Project files are in %s\n' "$project_dir"
