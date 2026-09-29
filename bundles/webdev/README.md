# Web Developer

For people building web and app projects on Omarchy. One install adds the packages that are not already on a default machine, four bar plugins, two agent skills, an editorconfig, and a project layout under `~/Work`. The install notification opens `introduction.md`.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `github-cli` | extra | `gh` for the optional private repo step in the create script |
| `docker-buildx` | extra | Buildx for image builds. It is also in Omarchy's base package list, so a default install already has it and removing this bundle will not remove it |
| `mkcert` | extra | A local certificate for `https://<name>.localhost`, only after you confirm, because trusting the CA uses `sudo` |
| `dbeaver` | extra | A desktop client for the Postgres service the create script writes |

No AUR packages.

Already in Omarchy, so they are not in `packages`:

- `docker`, `lazydocker`, and `lazygit` (base packages)
- mise (base package `mise-bin`)
- neovim (base package `nvim`)
- Chromium (base package). Other browsers are optional installs from the menu

Language runtimes are not pacman packages. The create script runs `mise use` inside the project, and only after asking, because that download can be large.

`docker-buildx` is the one overlap with the base list. It stays in this bundle so a machine that removed the base package still gets Buildx.

## Plugins

Each URL was checked against `omarchy-plugin-validate`. The schema cannot store a commit, so the reviewed revisions are written here. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

| Plugin | Id | Reviewed commit | What it adds |
| --- | --- | --- | --- |
| [robzolkos/omarchy-github](https://github.com/robzolkos/omarchy-github) | `robzolkos.github` | `6f361a45ee928119fbb73d26ca2173b9266a9e73` | Notifications, reviews, and your pull requests in the bar |
| [ZerubbabelT/portwatch](https://github.com/ZerubbabelT/portwatch) | `zeru.portwatch` | `9878e488a4c7d90977a0944258e336756ac1768e` | Which local ports are listening, and a way to stop them |
| [Majkelll/omarchy-docker](https://github.com/Majkelll/omarchy-docker) | `io.github.majkelll.omarchy-docker` | `f5dd6bd53cc1e650d274441583735bb82b5c2410` | Container status, logs, and start/stop |
| [dingyi/omaportless](https://github.com/dingyi/omaportless) | `dingyi.omaportless` | `894ebae20f812d2dbc99174aa75d724ca4821c64` | A stable `<name>.localhost` name for a dev server |

Port Watch and omaportless both notice local listeners. Both stay. Port Watch is how you see the process and stop it. omaportless is how you give that server a name you can open and bookmark. The Docker plugin is the bar control for containers; lazydocker, already in Omarchy, is the full-screen TUI the launcher opens later.

## Config

`config/editorconfig` is copied to `~/.config/omarchy-bundles/webdev/editorconfig`. The create script copies it into a new project as `.editorconfig` when `BUNDLE_DIR` is set.

## Project layout

`omarchy bundle project new webdev <name>` creates `~/Work/<name>/{src,docs,infra}` and `.omarchy-project`, then shows `scripts/create-project.sh` and asks before running it.

The script asks for a framework with `gum choose`: Rails, Next.js, Angular, Phoenix, plain static site, or none.

- Rails runs `mise use ruby`, then, after a second confirm, `rails new . --skip-git --force`. `--force` is there because the layout folders already exist.
- Next.js runs `mise use node`, then `npx create-next-app@latest .`
- Angular runs `mise use node`, then `npx @angular/cli new <name> --directory .`
- Phoenix runs `mise use elixir`, then `mix phx.new .`
- A plain static site writes `src/index.html` and does not download anything.
- `none` skips mise and generators.

It always writes `compose.yaml` (Postgres 17), `.env.example`, `.gitignore`, and `docs/cloudflare.md`. The Cloudflare file is a TODO. It tells you to ask before any account, token, or tunnel step, and the script never contacts Cloudflare.

mkcert runs only if you confirm, and `sudo mkcert -install` is a separate confirm. `git init` and a first commit are local. `gh repo create --private --source . --push` runs only if you confirm.

Without a terminal, the framework is the first line of stdin, and every confirm is treated as no. `printf 'none\n' | ./scripts/create-project.sh` creates the folders, compose file, and git repository, and does not call mise, npx, mkcert, sudo, or gh.

## Launcher

There is no launcher field in `bundle.json`. This is the flow to use after a project exists. A Quickshell button for it is later work.

1. Open a terminal in the project and run `tdl` inside Omarchy's tmux session. `tdl` is the dev layout: editor, agent, and a shell (`manual/20-shell-functions.md`).
2. Open the browser at `https://<name>.localhost` (the mkcert name omaportless is for).
3. Open lazydocker with `omarchy-launch-docker-tui`.
4. Use the GitHub bar plugin (`robzolkos.github`) for pull requests.

## Conflicts

None.
