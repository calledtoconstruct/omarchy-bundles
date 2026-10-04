# Cyber lab

This bundle installs a lab bench on the Omarchy you already use. It is for systems, files, and captures you are allowed to test. It is not a second operating system, and it is not a permission slip.

## What was installed

Network capture and mapping: `nmap`, `wireshark-qt`, `tcpdump`, `termshark`, `ngrep`, `tcpflow`, `mtr`, `openbsd-netcat`.

Web inspection: `zaproxy`, `mitmproxy`.

Binaries: `ghidra`, `radare2`, `python-capstone`, `gdb`, `strace`, `ltrace`.

Files and disks: `binwalk`, `sleuthkit`, `testdisk`, `foremost`, `perl-image-exiftool`.

Offline password recovery: `hashcat`, `john`. These work on hashes and files you hold. The bundle does not ship a wordlist and does not run either tool.

Your own host: `lynis`, `clamav`, `ssh-audit`.

`whois` and `socat` are already in the Omarchy base install, so they are not listed again.

Wireshark can capture only if your user is in the `wireshark` group. This install does not change groups.

## A lab folder

```
omarchy bundle project new cyber lab
```

That creates `~/Work/lab/` with `notes/`, `pcaps/`, `samples/`, `findings/`, and a `scope.md`. Fill in who authorized the work before you test anything.

## What this bundle leaves out

Kali's exploitation, wireless-attack, and social-engineering metapackages are not here. That includes Metasploit, Hydra, Aircrack-ng, and SQLmap. Install one of those yourself if a specific engagement needs it.
