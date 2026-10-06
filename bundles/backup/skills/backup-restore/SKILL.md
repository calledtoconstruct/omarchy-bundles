---
name: backup-restore
description: Extract one file or folder from a borgmatic archive into a new directory. Refuse a destination that already has files, and refuse the live home directory.
---

# Backup restore

Use this when the user wants one file or one folder back from a Borg archive. The whole-archive case uses the same command with no `--path`.

Requires a live `~/.config/borgmatic/config.yaml`. If it is missing, stop and use `backup-setup`.

Extract docs: https://torsion.org/borgmatic/docs/how-to/extract-a-backup/

## Which archive

When the user does not name an archive, use `latest`. When they are unsure which day, run `borgmatic repo-list` and let them pick a name from that output.

## Which path

Take the path they name and strip every leading `/`. `borgmatic extract --path` wants `home/you/Documents/notes.md`, not `/home/you/Documents/notes.md`.

Refuse an empty path, `.`, `..`, and any path that contains a `..` segment.

## Where it lands

Default destination:

```text
~/Restores/<yyyyMMdd-HHmmss>/
```

The user may name another directory. Refuse `/`, refuse their home directory, and refuse any directory that already contains a file. Create the destination before extract. The extracted path is under that directory, using the relative path from the archive. It does not replace the live file.

Show the command and ask, then run it:

```bash
borgmatic extract --archive latest --path home/you/Documents/notes.md --destination ~/Restores/20261005-090000
```

After it finishes, tell them the destination path. Copying that file back over the live one is a separate step. Wait until they ask.

Do not run `borgmatic prune`, `borgmatic delete`, or `borgmatic compact` from this skill. Do not run `borgmatic config bootstrap` without `--destination`. Without that flag it writes config files back to their original paths.
