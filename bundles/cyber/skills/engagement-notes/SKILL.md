---
name: engagement-notes
description: Write lab notes for an authorized cyber test into the cyber bundle project folder. Use when the user is recording scope, commands they already ran, or findings. Do not invent permission or write exploit steps.
---

# Engagement notes

Use this for a folder created by the cyber bundle, under `~/Work/<name>/`. The source of truth is `scope.md` plus files the user already has in `notes/`, `pcaps/`, `samples/`, and `findings/`.

## Check scope first

Read `scope.md`. If "Authorized by" or "In scope" is empty, stop. Ask who allowed the work and which hosts or files are in scope. Do not fill those fields from guesswork.

Stay inside that scope. If the user asks about a host or file that `scope.md` does not name, say so and wait.

## Write the note

Create `notes/<yyyy-mm-dd>-<topic>.md`:

```markdown
# Topic

Scope: scope.md

## What was examined

The host, file, or capture the user named.

## What the user already ran

The command, as the user wrote it, and what its output showed.

## Findings

- One observation, with the file or capture it came from.
```

Record commands the user already ran. Do not add new scan commands, payloads, or steps for breaking into a system. When a finding needs a follow-up, name the question and stop.

One topic, one notes file. Put packet captures in `pcaps/`, binaries in `samples/`, and a short write-up in `findings/` only when the user asks for that write-up.
