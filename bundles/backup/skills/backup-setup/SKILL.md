---
name: backup-setup
description: Write a borgmatic config for this user's files, create the Borg repository, and install the user backup timer. Ask before creating the repo, exporting the key, or enabling the timer.
---

# Backup setup

Use this when the user wants regular backups and `~/.config/borgmatic/config.yaml` is missing or still has the placeholders `YOU` and `CHANGE_ME`.

The sample installed by the backup bundle is `~/.config/omarchy-bundles/backup/config.yaml`. Borgmatic's own reference for these keys is https://torsion.org/borgmatic/reference/configuration/. Setup steps are https://torsion.org/borgmatic/docs/how-to/set-up-backups/.

Snapper already snapshots the Omarchy system disk. This skill sets up a Borg repository for the user's files. Leave snapper alone.

## Repository path

Ask where the repository should live. Use a directory on another filesystem, or an SSH path such as `ssh://user@host/./home.borg`.

Refuse a path inside a source directory. Compare filesystems with `findmnt -no SOURCE` on the repository's parent and on the source directory. When they match, say that a failed disk takes the backup with it, and stop. Continue on that disk only after the user explicitly says to.

Do not put the passphrase in the config. The user creates `~/.config/borgmatic/passphrase` in their editor, one line, and runs `chmod 600` on it. Do not ask them to paste the passphrase into the chat. Do not write that file yourself.

## Config

Copy the sample to `~/.config/borgmatic/config.yaml`. Replace `/home/YOU` with the home directory you are backing up. Replace `/CHANGE_ME/home.borg` with the repository path, including the exclude line for that path. Leave `encryption_passcommand` pointed at the passphrase file. Leave `one_file_system: true`.

Check it:

```bash
borgmatic config validate
```

Fix validation errors before creating the repository. Do not run `repo-create` while `YOU` or `CHANGE_ME` is still in the file.

## Create the repository

Show the command and ask, then run it:

```bash
borgmatic repo-create --encryption repokey-blake2
```

`repokey-blake2` stores the key inside the repository. The passphrase is what unlocks that key. Tell the user to keep a copy of the passphrase somewhere that is not this disk and not this archive. The sample excludes the passphrase file, so the archive does not contain it.

Offer `borgmatic key export` to a path the user names. Refuse a path under the source directory or inside the repository. Ask before writing the export. Do not print the exported key into the chat.

## Timer

The unit files live in the backup actions plugin, `units/omarchy-backup.service` and `units/omarchy-backup.timer`. After the user confirms, copy them to `~/.config/systemd/user/` and run:

```bash
systemctl --user daemon-reload
systemctl --user enable --now omarchy-backup.timer
```

The checked-in timer is daily, persistent, with a 30 minute random delay. For every six hours, set `OnCalendar=*-*-* 00/6:00:00`. For weekly, set `OnCalendar=Sun *-*-* 03:00:00`. Change only the `OnCalendar=` line.

The service runs `borgmatic create --verbosity 1`. It does not prune. `keep_daily`, `keep_weekly`, and `keep_monthly` sit in the config for a later `borgmatic prune` the user asks for.

`loginctl enable-linger "$USER"` lets the timer run while the user is logged out. It may prompt through polkit. Ask first.

Do not start the first backup in this skill. That is `backup-now`.
