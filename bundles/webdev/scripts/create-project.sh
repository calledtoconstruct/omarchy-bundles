#!/bin/bash

# Runs only from `omarchy bundle project new`, after that command has shown
# this file and you have confirmed. Safe to run again.

set -euo pipefail

project_dir=${PROJECT_DIR:-$PWD}
cd -- "$project_dir"
name=$(basename -- "$project_dir")

choose() {
  if [[ -t 0 && -t 1 ]]; then
    gum choose "$@"
  else
    local line
    IFS= read -r line || true
    printf '%s\n' "$line"
  fi
}

ask() {
  local prompt="$1"
  if [[ -t 0 && -t 1 ]]; then
    gum confirm "$prompt"
    return
  fi
  return 1
}

use_runtime() {
  local tool="$1"
  if ask "Install the ${tool} runtime with mise in this project? This can download over 100 MB."; then
    mise use "$tool"
  else
    echo "Skipped mise use ${tool}."
  fi
}

run_generator() {
  local label="$1"
  shift
  if ask "Run the ${label} generator? It downloads packages."; then
    "$@"
  else
    echo "Skipped the ${label} generator."
  fi
}

framework=$(choose "Rails" "Next.js" "Angular" "Phoenix" "plain static site" "none")
case $framework in
Rails | "Next.js" | Angular | Phoenix | "plain static site" | none) ;;
*)
  echo "Unknown framework: ${framework:-<empty>}. Choose Rails, Next.js, Angular, Phoenix, plain static site, or none." >&2
  exit 1
  ;;
esac

case $framework in
Rails) use_runtime ruby ;;
"Next.js" | Angular) use_runtime node ;;
Phoenix) use_runtime elixir ;;
"plain static site" | none) ;;
esac

case $framework in
Rails)
  run_generator Rails rails new . --skip-git --force
  ;;
"Next.js")
  run_generator "Next.js" npx create-next-app@latest .
  ;;
Angular)
  run_generator Angular npx @angular/cli new "$name" --directory .
  ;;
Phoenix)
  run_generator Phoenix mix phx.new .
  ;;
"plain static site")
  mkdir -p src
  if [[ ! -f src/index.html ]]; then
    printf '%s\n' '<!DOCTYPE html>' '<html lang="en">' '<head>' '<meta charset="utf-8">' "<title>${name}</title>" '</head>' '<body>' "<h1>${name}</h1>" '</body>' '</html>' >src/index.html
  fi
  ;;
none) ;;
esac

mkdir -p src docs infra

if [[ ! -f .editorconfig && -n ${BUNDLE_DIR:-} && -f $BUNDLE_DIR/config/editorconfig ]]; then
  cp -- "$BUNDLE_DIR/config/editorconfig" .editorconfig
fi

cat >compose.yaml <<'EOF'
services:
  db:
    image: postgres:17
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-webdev}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-webdev}
      POSTGRES_DB: ${POSTGRES_DB:-webdev}
    ports:
      - "5432:5432"
    volumes:
      - db:/var/lib/postgresql/data

volumes:
  db:
EOF

cat >.env.example <<'EOF'
POSTGRES_USER=webdev
POSTGRES_PASSWORD=webdev
POSTGRES_DB=webdev
EOF

cat >.gitignore <<'EOF'
.env
node_modules/
dist/
.angular/
_build/
deps/
tmp/
log/
EOF

cat >docs/cloudflare.md <<EOF
# Cloudflare

TODO: Cloudflare Pages or Tunnel for ${name}.

Ask before any account step. Do not create a Cloudflare account, an API token,
or a tunnel until the person who owns this project confirms that step.
EOF

host="${name}.localhost"
if ask "Create a local HTTPS certificate for ${host}? Trusting it runs sudo mkcert -install."; then
  if ask "Run sudo mkcert -install to trust the local CA?"; then
    sudo mkcert -install
  fi
  mkcert -cert-file "infra/${host}.pem" -key-file "infra/${host}-key.pem" "$host"
fi

git init -b main
if ! git config --get user.name >/dev/null; then
  git config user.name webdev
  git config user.email webdev@localhost
fi
git add -A
if ! git diff --cached --quiet; then
  git -c commit.gpgsign=false commit -m "Start the webdev project"
fi

if ask "Create a private GitHub repository and push this project?"; then
  gh repo create --private --source . --push
fi

cat <<EOF

Launcher, once you want to work in this project:

1. Open a terminal here and run tdl inside Omarchy's tmux session. That is the dev layout: editor, agent, and a shell.
2. Open the browser at https://${host}
3. Open lazydocker (omarchy-launch-docker-tui) for the compose stack.
4. Use the GitHub bar plugin for pull requests.

EOF
