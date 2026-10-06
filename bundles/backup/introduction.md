# Backup and Restore

This bundle copies your files to a Borg repository on another disk or another machine. Omarchy already uses snapper for btrfs snapshots of the system disk. Those snapshots roll the machine back after an update. They stay on that disk. This bundle is the copy that can survive the disk.

## What was installed

`borg` and `borgmatic`, both from extra. borgmatic stores the backup settings in one YAML file and runs Borg.

A sample of that file is at `~/.config/omarchy-bundles/backup/config.yaml`. It is not live until you copy it to `~/.config/borgmatic/config.yaml` and replace `YOU` and `CHANGE_ME`.

Two bar plugins:

- Backup status shows the next run, an in-progress backup, or that the schedule is missing. It does not start a backup.
- Backup actions opens a terminal menu: back up now, list archives, restore one file or folder into `~/Restores/`, or install the daily timer.

Three skills walk an agent through setup, an immediate backup, and a restore. The restore skill writes into a new folder. It does not replace the live file in place.

## Before the first backup

Pick a repository path on another filesystem, or an `ssh://` path. Create a passphrase file at `~/.config/borgmatic/passphrase`, mode 600. Keep a copy of that passphrase off this machine. The sample config excludes the passphrase file from the archive, so the archive cannot unlock itself.

Then:

```
borgmatic config validate
borgmatic repo-create --encryption repokey-blake2
```

The actions plugin can install `omarchy-backup.timer` for your user after you confirm. The timer runs `borgmatic create`. It does not prune old archives.

## What this bundle leaves out

Timeshift, btrbk, restic, Vorta, Pika Backup, and Kopia. Snapper is already on the machine for system snapshots. One file-backup program is enough for this sample.
