---
name: capture-notes
description: Summarize a packet capture the user already saved in a cyber lab folder. Use when they name a pcap. Record capinfos and tshark statistics. Do not start a capture or extract secrets.
---

# Capture notes

Use this for a pcap the user already put in `pcaps/` under a cyber lab folder (`~/Work/<name>/`). Read `scope.md` first. If "Authorized by" or "In scope" is empty, stop and ask.

## Read the file

Run only these commands, with the path the user named:

```bash
capinfos <file>
tshark -r <file> -q -z io,phs -z conv,ip
```

`capinfos` comes with Wireshark. If either command is missing, say so and stop. Do not capture from an interface. Do not add display filters that hunt for passwords, tokens, or cookies. Do not follow a stream in order to pull out a secret.

## Write the note

Create `notes/<yyyy-mm-dd>-capture.md`:

```markdown
# Capture

File: pcaps/<file>
Scope: scope.md

## File

Duration, packet count, and whether the file looks truncated, from capinfos.

## Protocols

The protocol hierarchy tshark printed, shortened to the rows that carry the traffic.

## Conversations

The busiest IP conversations, as addresses and bytes. No payload.
```

One capture, one note. A question about something the statistics do not show stays a question.
