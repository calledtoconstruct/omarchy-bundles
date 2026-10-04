# Cyber lab

For authorized security testing and research on the Omarchy machine you already use. One install adds official Arch packages for capture, web inspection, reverse engineering, forensics, offline password recovery, and a host audit, plus one agent skill and a lab folder. No AUR packages. No bar plugins. The install notification opens `introduction.md`.

Other systems make this a distribution. Kali sorts thousands of tools into metapackages (`kali-tools-information-gathering`, `kali-tools-forensics`, `kali-tools-reverse-engineering`, `kali-tools-exploitation`, and the rest) and `kali-linux-everything` installs all of them. Parrot ships a Home edition for daily use and a separate Security edition. BlackArch is an Arch overlay with a category for almost every tool. Fedora's Security Lab is a live spin whose package set is the lab, not a second desktop you keep. Omarchy stays the daily system. This bundle is the lab you add and remove.

The package list follows the categories those projects share, using names that exist in `extra` today, and it stops before Kali's exploitation, wireless-attack, and social-engineering groups.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `nmap` | extra | Host and service discovery |
| `wireshark-qt` | extra | Packet capture and decode |
| `tcpdump` | extra | Capture from the terminal |
| `termshark` | extra | A terminal view of the same captures |
| `ngrep` | extra | Search packet payloads |
| `tcpflow` | extra | Reassemble TCP streams to files |
| `mtr` | extra | Path and loss |
| `openbsd-netcat` | extra | Open a socket by hand |
| `zaproxy` | extra | OWASP ZAP, the web scanner in the official repos |
| `mitmproxy` | extra | Inspect HTTP you are allowed to intercept |
| `ghidra` | extra | Reverse engineering. This is the large download |
| `radare2` | extra | Disassemble and debug |
| `python-capstone` | extra | Disassembly library used beside radare2 |
| `gdb` | extra | Debugger |
| `strace` | extra | Trace syscalls |
| `ltrace` | extra | Trace library calls |
| `binwalk` | extra | Find embedded files in a firmware image |
| `sleuthkit` | extra | Filesystem forensics |
| `testdisk` | extra | Partition recovery and PhotoRec |
| `foremost` | extra | Carve files by header |
| `perl-image-exiftool` | extra | Read file metadata |
| `hashcat` | extra | Offline password recovery |
| `john` | extra | Offline password recovery |
| `lynis` | extra | Audit this machine |
| `clamav` | extra | Scan a file for known malware |
| `ssh-audit` | extra | Read an SSH server's offered algorithms |

`whois` and `socat` are already in `install/omarchy-base.packages`. They are not repeated here.

`hashcat` and `john` recover passwords from material you have. The bundle does not ship a wordlist, and install does not run either program.

Wireshark's capture helper needs the user in the `wireshark` group. A bundle install does not change group membership.

## Left out on purpose

These are in Arch or in Kali, and they are not in this bundle: `metasploit`, `sqlmap`, `hydra`, `aircrack-ng`, `bettercap`, ExploitDB, and the wireless-attack suites. A named engagement can install the one package it needs. A default lab does not.

## Project

```
omarchy bundle project new cyber lab
```

That creates `~/Work/lab/` with `notes/`, `pcaps/`, `samples/`, `findings/`, and `scope.md`. The create script writes `scope.md` only when it is missing. It does not download anything and it does not use `sudo`.

The `engagement-notes` skill writes notes from commands the user already ran. It stops when `scope.md` does not name who authorized the work.

## Conflicts

None.
