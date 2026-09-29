# Web Developer

This bundle is for building web and app projects. It adds the packages that are **not** already on a default Omarchy machine, four bar plugins, two agent skills, an editorconfig, and a project layout under `~/Work`.

Already installed with Omarchy, and so left out of this bundle: Docker, lazydocker, lazygit, mise, Neovim, and Chromium. Language runtimes are not pacman packages. The create script runs `mise use` inside the project, and only after asking, because that download can be large.

## What was installed

| Package | What it is for |
| --- | --- |
| `github-cli` | `gh`, including the optional private-repo step in the create script |
| `docker-buildx` | Buildx for image builds. A default Omarchy install already has it, so removing this bundle will not remove it |
| `mkcert` | A local certificate for `https://<name>.localhost`, only after you confirm, because trusting the CA uses `sudo` |
| `dbeaver` | A desktop client for the Postgres service the create script writes |

DBeaver is the new app in the launcher. `gh` and `mkcert` are commands.

An editorconfig was copied to `~/.config/omarchy-bundles/webdev/editorconfig`. If that file was already yours, install left it alone.

## A project

```
omarchy bundle project new webdev my-site
```

The folder is created under `~/Work`. The script can:

1. Run `mise use` for the language versions the project asks for.
2. Trust a local CA with `mkcert` and issue a certificate for `https://<name>.localhost`.
3. Write a Postgres service you can open in DBeaver.

Each of those waits for a yes. Declining still leaves the project directory.

## The bar

If you enabled the plugins, the bar can show:

- **GitHub** reviews, notifications, and your pull requests.
- **Ports** that are listening, and a way to stop them.
- **Docker** container status, logs, and start/stop.
- A stable **`<name>.localhost`** name for a dev server.

> Portwatch and the localhost name are the two that matter while a server is running. GitHub and Docker are there the rest of the time.

Enable one later with `omarchy plugin enable` and its id, for example `omarchy plugin enable zeru.portwatch`.

## Skills

- **webdev-project** for the layout of a new app.
- **frontend-review** for a pass over the interface.

Ask the agent for the skill and point it at the project directory.
