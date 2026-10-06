# Backup and Restore

For a regular copy of your files, and for putting one file or folder back after a crash or a mistake. One install adds Borg and borgmatic from the official repositories, two bar plugins, three agent skills, and a sample borgmatic config. The install notification opens `introduction.md`.

Snapper, `btrfs-progs`, and `limine-snapper-sync` are already in `install/omarchy-other.packages`. `rsync` is already in the base install. They are not repeated here. Snapper snapshots the system disk so an update can be rolled back. Those snapshots live on that disk. This bundle is the copy on another disk or another machine.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `borg` | extra | Deduplicating, encrypted archives. borgmatic depends on it. Listing it here puts it on the bundle ledger, so removing the bundle can remove it |
| `borgmatic` | extra | One YAML file for the repository, the paths, the excludes, and the passphrase command. `create`, `repo-list`, and `extract` are the actions the plugins and skills use |

No AUR packages.

`borg` 1.4.5-1 and `borgmatic` 2.1.7-1 were the extra versions in the local package database while this bundle was written. The commands below are the ones documented for borgmatic 1.9 and later: https://torsion.org/borgmatic/docs/how-to/set-up-backups/ and https://torsion.org/borgmatic/docs/how-to/extract-a-backup/

The Arch package does not ship a systemd timer. The actions plugin carries a user timer and installs it only after a confirm. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

## Sample config

`config/config.yaml` is copied to `~/.config/omarchy-bundles/backup/config.yaml`. Install does not copy it into `~/.config/borgmatic/`, and it does not create a repository. `YOU` and `CHANGE_ME` in the sample are placeholders.

The live file, once you write it, is `~/.config/borgmatic/config.yaml`. The passphrase file is `~/.config/borgmatic/passphrase`, mode 600. The sample tells borgmatic to read that file and to leave it out of the archive. Keep another copy of the passphrase off this machine. With `repokey-blake2`, the key sits inside the repository and the passphrase is what unlocks it.

`keep_daily`, `keep_weekly`, and `keep_monthly` apply when someone runs `borgmatic prune`. The timer's service runs `borgmatic create` only.

## Plugins

The schema cannot store a commit. Reviewed at `0470c62cb1757af3521dec6092bdcb6193a3cf12` for the status plugin and `726f4a524aac0a187ef237e2e72e7364616118f3` for the actions plugin.

| Plugin | Id | What it adds |
| --- | --- | --- |
| [calledtoconstruct/omarchy-backup-status](https://github.com/calledtoconstruct/omarchy-backup-status) | `calledtoconstruct.backup-status` | A bar badge. `run` while borgmatic or borg is running, or the user service is active. `3h`, `45m`, or `2d` until the next timer elapse. `due` when that time has passed. `err` after a failed service result. `off` when `omarchy-backup.timer` is missing or not running. `set` when `~/.config/borgmatic/` has no YAML file. Click opens that YAML. The badge does not start a backup and does not unlock the repository |
| [calledtoconstruct/omarchy-backup-actions](https://github.com/calledtoconstruct/omarchy-backup-actions) | `calledtoconstruct.backup-actions` | A bar button, `job`. Click opens a terminal menu. Backup now starts `omarchy-backup.service` after a confirm, or `borgmatic create` when that unit is not installed. List archives runs `borgmatic repo-list`. Restore extracts one path into a new directory, by default `~/Restores/<timestamp>/`. Install the schedule copies the user units and enables the timer. The menu does not prune, delete, or compact |

## Skills

| Skill | When it applies |
| --- | --- |
| `backup-setup` | Write `~/.config/borgmatic/config.yaml`, create the repository, and install the user timer. Asks before `repo-create`, before writing a key export, and before `systemctl --user enable` |
| `backup-now` | Say whether a backup is running and when the next one is. Start one backup after a confirm |
| `backup-restore` | Extract one file or folder into a new directory. Lists archives when the archive name is unknown |

The skills follow the same rules as the menu. A restore destination that already contains files is refused. The live home directory is refused as a destination.

## Schedule

The actions plugin writes:

```
~/.config/systemd/user/omarchy-backup.service
~/.config/systemd/user/omarchy-backup.timer
```

The service is `borgmatic create --verbosity 1` at idle priority. The default timer is `OnCalendar=daily` with `Persistent=true` and a 30 minute random delay, so a machine that was off still runs the missed backup. The menu can write `OnCalendar=*-*-* 00/6:00:00` or `OnCalendar=Sun *-*-* 03:00:00` instead.

A user timer runs while you are logged in. `loginctl enable-linger "$USER"` lets it run while you are logged out. That may ask through polkit. The skill asks before it.

## Restore

```
borgmatic extract --archive latest --path home/YOU/Documents/notes.md --destination ~/Restores/20261005-090000
```

`--path` has no leading slash. The file lands under the destination, not on top of the original. Put the original back by copying it yourself after you have looked at the extracted copy.

## Left out on purpose

Timeshift and btrbk overlap snapper, and btrbk wants root. restic is in extra and has no config file or timer in its package. Vorta and Pika Backup are desktop clients on top of Borg. Pika Backup 0.8.4-1 in extra depends on `borg`. Kopia is AUR-only (`kopia`, maintained by gromit). This sample keeps one program, borgmatic, so the badge, the menu, and the skills all read the same config.

A repository path may be `ssh://user@host/./home.borg`. rclone is not required for that.

## Conflicts

None.
