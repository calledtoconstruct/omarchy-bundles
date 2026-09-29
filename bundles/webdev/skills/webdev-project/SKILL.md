---
name: webdev-project
description: Layout, runtime, compose stack, logs, tests, and agent conventions for a project created by the webdev bundle.
---

# Webdev project

Use this when working in a project created by the webdev bundle (`omarchy bundle project new webdev <name>`), or when the folder has `.omarchy-project` naming that bundle.

## Layout

- `src/` holds application code. A plain static site keeps `src/index.html` here.
- `docs/` holds notes for people, including `docs/cloudflare.md`.
- `infra/` holds local HTTPS certificates (`<name>.localhost.pem` and the key) when mkcert was run.
- `compose.yaml` and `.env.example` sit at the project root. `.env` is gitignored. Do not commit secrets.
- Language runtimes are per project, through mise (`mise.toml`), not through pacman.

## Start the stack

1. From the project root, trust the mise config if it exists: `mise trust` and `mise install`.
2. Start Postgres: `docker compose up -d`. The service is `db`, published on port 5432, using `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB` from `.env` (see `.env.example`).
3. Start the app with the framework's own command (`bin/rails server`, `npm run dev`, `ng serve`, `mix phx.server`). A project created with framework "none" has no app server.

## Logs

- Postgres and any other compose services: `docker compose logs -f db` from the project root.
- The app process: the terminal pane where it was started. Omarchy's dev layout (`tdl` inside tmux) keeps that pane next to the editor.
- Do not scrape `~/.local/share/docker` or the Postgres data volume for logs.

## Tests

Run the framework's test command from the project root, after mise and compose are up when the tests need the database.

- Rails: `bin/rails test`
- Next.js: `npm test`
- Angular: `npx ng test`
- Phoenix: `mix test`
- Plain static site, or framework "none": there is no generated suite. Say so instead of inventing one.

## Conventions

- Match `config/editorconfig` from this bundle: UTF-8, LF, two-space indent, final newline.
- Keep changes inside the project. Do not install global packages to make one app build.
- Ask before a download over about 100 MB, before `sudo`, before `gh repo create`, and before any Cloudflare, GitHub, or other account step. `docs/cloudflare.md` is a TODO, not a setup script.
- Prefer the generators' own files over rewriting them.
