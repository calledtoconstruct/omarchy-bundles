---
name: firmware-inventory
description: Inventory a firmware or binary file the user already saved in a cyber lab folder. Use binwalk's listing and exiftool. Do not extract or execute the file.
---

# Firmware inventory

Use this for a file the user already put in `samples/` under a cyber lab folder (`~/Work/<name>/`). Read `scope.md` first. If "Authorized by" or "In scope" is empty, stop and ask.

## Read the file

Run only these commands, with the path the user named:

```bash
binwalk <file>
exiftool <file>
```

`binwalk` with no extra flags prints a listing. Do not pass `-e` or `--extract`. Do not run, mount, or emulate the file. If a command is missing, say so and stop.

## Write the note

Create `notes/<yyyy-mm-dd>-firmware.md`:

```markdown
# Firmware inventory

File: samples/<file>
Scope: scope.md

## Metadata

The exiftool fields that name a type, a date, or a vendor.

## Embedded files

Each binwalk hit: offset and description. No extracted bytes.
```

One file, one note.
