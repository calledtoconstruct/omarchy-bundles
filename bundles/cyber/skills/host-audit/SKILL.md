---
name: host-audit
description: File a lynis or ssh-audit report the user already produced into a cyber lab folder. Do not run sudo and do not change the machine.
---

# Host audit

Use this when the user pastes output from `lynis audit system` or `ssh-audit`, or points at a report they already saved. The lab folder is `~/Work/<name>/`. Read `scope.md` first. If "Authorized by" or "In scope" is empty, stop and ask.

Do not run `lynis` or `ssh-audit` yourself. Do not use sudo. Do not edit sshd, firewall rules, or packages. The user runs the tool. This skill files the output.

## Write the note

Save the raw output at `findings/<yyyy-mm-dd>-audit.txt` when the user pasted it and it is not already a file.

Create `notes/<yyyy-mm-dd>-audit.md`:

```markdown
# Host audit

Source: findings/<file>
Scope: scope.md

## Warnings

Each warning the report named, in the report's words, with its suggestion left as a suggestion.

## Skipped

Anything the report said it could not check.
```

Do not turn a suggestion into a command the user should run next. One report, one note.
