# Omarchy bundles

An Omarchy bundle is a folder of data for one activity. Its manifest lists the Arch packages to install, the shell plugins to add, the agent skills to link, the config files to copy, and an optional project layout. Installing a bundle copies that folder into `~/.local/share/omarchy-bundles/<id>/` and follows the list.

Nothing in the bundle runs during install. Packages go through `omarchy-pkg-add` and plugins through `omarchy-plugin-add`. A ledger records which bundle owns each package, plugin, skill link, and config file. Removing a bundle drops only what no remaining bundle still owns, and only what you had not already installed yourself.

These examples are for the bundle commands on the [`bundles` branch](https://github.com/calledtoconstruct/omarchy/tree/bundles) of [calledtoconstruct/omarchy](https://github.com/calledtoconstruct/omarchy). The manifest rules are in [`manual/52-bundles.md`](https://github.com/calledtoconstruct/omarchy/blob/bundles/manual/52-bundles.md) on that branch. This catalog is the set of bundles proposed in [Discussion #13551](https://github.com/omacom/omarchy/discussions/13551).

## Install

`omarchy bundle add` accepts a local folder, a git URL, or a registry name it does not serve yet.

Clone this catalog and pass one bundle folder:

```bash
git clone https://github.com/calledtoconstruct/omarchy-bundles.git
omarchy bundle add ./omarchy-bundles/bundles/<id>
```

A git URL is a development source. The command prints a development/unsafe source warning, clones the repository, and treats the clone root as the bundle. Use that form for a repository whose root contains `bundle.json`. Each bundle in this catalog lives under `bundles/<id>/`, so install one from here by path after cloning.

A name shaped like `publisher/name` or `publisher/name@version` is reserved for the plugin registry. The command recognizes it and exits with "registry not available yet".

`omarchy bundle add --dry-run <path>` prints the plan and changes nothing. `--yes` skips the confirmation. Without a terminal, and without `--yes`, install and remove both refuse to continue.

```bash
omarchy bundle list
omarchy bundle remove <id>
omarchy bundle reset <id>
omarchy bundle project new <id> <project-name>
```

`omarchy bundle project new` creates the project folders and a `.omarchy-project` marker, prints the create script, and asks before running it.

## Bundles

| Bundle | Who it is for | What it installs |
| --- | --- | --- |
| [webdev](bundles/webdev/README.md) | Web and app developers | `github-cli`, `docker-buildx`, `mkcert`, `dbeaver`, four bar plugins, two skills, and a project layout |
| [creator](bundles/creator/README.md) | Screencasters, YouTube, and streams | `v4l2loopback-dkms`, `v4l2loopback-utils`, `easyeffects`, `audacity`, one AUR plugin for OBS, five bar plugins, two skills, and a dated project |
| [local-ai](bundles/local-ai/README.md) | Running and building with local models | `llama-cpp`, `nvtop`, `uv`, four bar plugins, two skills, and a project under `~/AI`. Ollama stays on the Install menu because its GPU packages cannot be installed together |
| [study](bundles/study/README.md) | Students and self-learners, one folder per course | `anki`, `typst`, `pandoc-cli`, `zathura`, `zathura-pdf-mupdf`, `harper`, AUR `zotero-bin`, four bar plugins, three skills, and `~/School/<term>/<course>` |
| [gaming](bundles/gaming/README.md) | PC games | `gamemode`, `mangohud`, `gamescope`, `goverlay`, the lib32 builds of GameMode and MangoHud, AUR `protonup-qt`, three bar plugins, one skill, and a MangoHud config. No project. Steam and Heroic stay on the Install menu |
| [cyber](bundles/cyber/README.md) | Authorized security testing and research | Official packages for capture, web inspection, reverse engineering, forensics, offline password recovery, and a host audit. One bar plugin, four skills, and a lab folder. No AUR packages and no attack frameworks |
| [backup](bundles/backup/README.md) | Regular file backups and restoring a file or a folder | `borg` and `borgmatic` from extra. Two bar plugins, three skills, and a sample config. Snapper is already installed and stays the system-disk rollback |

## Safety

- Installing a bundle never runs a file from the bundle. The copy, the package installs, the plugin installs, the skill links, and the config copies are the whole install.
- A create script runs only from `omarchy bundle project new`, after the command has printed the script and you have confirmed.
- A create script in this catalog asks before a download over about 100 MB, before `sudo`, before creating anything on GitHub, and before signing into or changing an account.
- Removal is reference counted. A package or plugin that another installed bundle still lists stays installed. A config file the bundle copied is checksummed; remove deletes it only when those bytes are unchanged. An edit you made after install is left on disk. `omarchy bundle reset <id>` moves a differing live file to `<file>.bak.<timestamp>` and writes the installed bundle's copy.

## AUR policy

Package sources, in order: the official Arch repositories (`core`, `extra`, `multilib`), then an installer Omarchy already ships, then the AUR.

An AUR package is allowed only when no official package does the job, and the maintainer is well known (Arch staff, or someone with a long record of maintaining many packages), or the package repackages that project's own release. Each one is recorded in [AUR-PACKAGES.md](AUR-PACKAGES.md) with the reason. Low-vote, single-package, or out-of-date AUR packages need a strong reason or they are dropped. `scripts/check-packages.sh` fails when a name is in neither the official repos nor the AUR, and it fails when an AUR package is flagged out of date.

The rules for adding a bundle are in [CONTRIBUTING.md](CONTRIBUTING.md). Limits of `bundle.json` that a real bundle runs into go in [SCHEMA-GAPS.md](SCHEMA-GAPS.md).

## Where this came from

[Discussion #13551](https://github.com/omacom/omarchy/discussions/13551) asks whether a bundle should be a third registry package type, beside plugin and theme. [Discussion #12342](https://github.com/omacom/omarchy/discussions/12342), "Omarchy for all-jobs", proposed task presets for different kinds of work. These bundles are that idea as separate, reference-counted installs.

[mightywomble/omarchy_setup](https://github.com/mightywomble/omarchy_setup) saves plugins, applications, and keybindings from one JSON and applies that snapshot to a fresh machine. A bundle here is one activity you can add or remove next to others. Two bundles can share a package, and that package stays until the last of them is removed.
