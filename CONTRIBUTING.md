# Contributing a bundle

Add a folder at `bundles/<id>/`. The id matches `bundle.json`, uses the same shape as a plugin id (`^[A-Za-z0-9][A-Za-z0-9._-]*$`), and is not in the reserved `omarchy.*` namespace. Do not add unknown keys to the manifest. `omarchy bundle validate` rejects them.

```
bundles/<id>/bundle.json
bundles/<id>/README.md
bundles/<id>/skills/<name>/SKILL.md
bundles/<id>/config/...
bundles/<id>/scripts/create-project.sh
```

`bundle.json` is schemaVersion 1, as checked by `omarchy-bundle-validate` on the [`bundles` branch](https://github.com/calledtoconstruct/omarchy/blob/bundles/bin/omarchy-bundle-validate). Set `"packageType": "bundle"`. Required fields are `id`, `name`, `version`, `description`, `packages`, `aurPackages`, `plugins`, `skills`, `config`, and `conflicts`. `packages` are official Arch names and install with `omarchy-pkg-add`. `aurPackages` are AUR names and install with `omarchy-pkg-aur-add`. Removal uses `omarchy-pkg-drop` and `omarchy-pkg-aur-drop`. `project` and `introduction` are optional. `introduction` is a Markdown file in the bundle. Install sends a notification that opens it in Omawrite. When a bundle creates projects, set `project.create` to `scripts/create-project.sh`. Skill entries are paths like `skills/<name>`. Config `source` paths live under `config/`. Paths are relative, and `..` is rejected.

The bundle README says who it is for, what it installs, any AUR packages and their maintainers, the project layout, how the launcher or create script behaves, and which other bundle ids it conflicts with.

## Packages

Search in this order:

1. Official Arch repositories: `core`, `extra`, then `multilib`.
2. An installer Omarchy already ships (`omarchy-install-*` and the other commands in the Omarchy tree).
3. The AUR.

Do not list a package Omarchy already installs by default. Name it in the bundle README as "already in Omarchy" and leave it out of `packages`.

An AUR package is allowed only when no official package works, and either:

- the maintainer is well known and respected (Arch staff, or a long track record maintaining many packages), or
- the package repackages the upstream project's official release.

Record every AUR package in [AUR-PACKAGES.md](AUR-PACKAGES.md): the package, the bundle, the maintainer, and why no official package works. A low-vote package, a maintainer who publishes little else, or a package flagged out of date needs a strong reason written in that file, or it should be dropped.

`scripts/check-packages.sh` queries the [Arch package search](https://archlinux.org/packages/search/json/) and the [AUR RPC](https://aur.archlinux.org/rpc/v5/info). It fails if a name is in neither. It prints a warning for each AUR package (maintainer, votes, out-of-date flag, and how many AUR packages that maintainer has) and fails if the package is flagged out of date.

## Plugins

Every plugin is a real public repository with a valid `manifest.json`. In `plugins`, give its git URL, or the id of a plugin the person already has installed. The schema has no tag or commit field, so a pin cannot be written down yet. That limit is recorded in [SCHEMA-GAPS.md](SCHEMA-GAPS.md). Do not invent a key for it.

## Create scripts

`scripts/create-project.sh` is bash, starts with `set -euo pipefail`, and is safe to run again. Use `gum` for prompts. Ask before:

- a download over about 100 MB
- `sudo`
- creating a repository, gist, or other object on GitHub
- signing into an account, or changing one

Installing the bundle must not run this script. `omarchy bundle project new` prints it and asks first. The script's working directory is the new project folder. `PROJECT_DIR` and `BUNDLE_DIR` are set.

## Skills

Each skill folder contains `SKILL.md` with YAML frontmatter for `name` and `description`. The body says when to use the skill and the steps to follow. Do not put secrets, tokens, or account-specific values in it. If a public skill was the model, name it and link it. Do not copy its text.

## Checks

From a checkout of this repo, with [calledtoconstruct/omarchy](https://github.com/calledtoconstruct/omarchy) on the `bundles` branch available as `../omarchy` or as `OMARCHY_PATH`:

```bash
shellcheck scripts/*.sh
scripts/validate-all.sh
scripts/check-packages.sh
```

GitHub Actions does the same on Ubuntu, with `jq` and `curl`. It does not run pacman.
