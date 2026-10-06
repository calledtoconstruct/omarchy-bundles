---
name: backup-now
description: Report whether a borgmatic backup is running and when the next one is scheduled. Start one backup after the user confirms.
---

# Backup now

Use this when the user asks for a backup now, asks when the next one is, or asks whether one is already running.

Requires `~/.config/borgmatic/config.yaml` from `backup-setup`. If that file is missing, or it still contains `YOU` or `CHANGE_ME`, stop and use `backup-setup`.

## Status

A backup is in progress when any of these is true:

- `pgrep -x borgmatic` or `pgrep -x borg` finds a process
- `systemctl --user show omarchy-backup.service -p ActiveState --value` prints `active` or `activating`

The next run is `systemctl --user show omarchy-backup.timer -p NextElapseUSecRealtime --value`. The last service result is `systemctl --user show omarchy-backup.service -p Result -p ExecMainStatus -p ExecMainExitTimestamp`.

When a backup is in progress, say so and do not start another.

When the timer unit is not installed, say that the schedule is missing. Starting one backup does not install the timer. Installing the timer is `backup-setup`.

## Start

Show the command and ask, then run one of these.

When `systemctl --user show omarchy-backup.service -p LoadState --value` prints `loaded`:

```bash
systemctl --user start omarchy-backup.service
```

Otherwise:

```bash
borgmatic create --verbosity 1
```

The service is the better of the two. Its journal is `journalctl --user -u omarchy-backup.service`, and the status badge treats the service as in progress.

Do not run `borgmatic prune`, `borgmatic delete`, `borgmatic compact`, or `borgmatic check` from this skill.
