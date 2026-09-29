---
name: proton-troubleshooter
description: Diagnose a Steam game that fails to start under Proton. Check ProtonDB, try another Proton or GE-Proton, read the Proton log, and review launch options and GPU drivers.
---

# Proton troubleshooter

Use this when a Steam game does not start, or starts and dies, under Proton. Work one change at a time and say which change you are about to try.

Sources for the commands below:

- Proton's runtime options, including `PROTON_LOG`: https://github.com/ValveSoftware/Proton#runtime-config-options
- Reports from other people on the same game: https://www.protondb.com
- GE-Proton and other tools, installed with ProtonUp-Qt: https://davidotek.github.io/protonup-qt
- Feral GameMode: https://github.com/FeralInteractive/gamemode
- MangoHud: https://github.com/flightlessmango/MangoHud
- Gamescope: https://github.com/ValveSoftware/gamescope

## What failed

Ask for the game's Steam app id, the Proton version in the game's Compatibility tab, and what happened: no window, a crash back to the library, or a window that stays black. The app id is in the store URL, `store.steampowered.com/app/<id>`.

## ProtonDB

Open `https://www.protondb.com/app/<id>`. Read the recent reports that match this GPU vendor. Note a Proton version that those reports say starts the game. A report from years ago is a hint, not a prescription.

## The log

In the game's launch options, set:

```text
PROTON_LOG=1 %command%
```

Start the game once, then remove that variable. Proton writes `$HOME/steam-<appid>.log` unless `PROTON_LOG_DIR` points somewhere else. Read the end of the log. A missing Vulkan driver, a missing 32-bit library, or a Wine crash names itself. Quote that line in the note you leave for the student of the problem.

## Another Proton

In Steam, open the game's Properties, Compatibility, and force a current Proton version. If ProtonDB named one, try that one next.

For GE-Proton, open ProtonUp-Qt, install one GE-Proton build for Steam, then restart Steam so the new version appears in the Compatibility list. Pick that version for this game only. The Flathub build is `net.davidotek.pupgui2`. The package in this bundle is `protonup-qt`.

## Launch options

Add these in front of `%command%`, one experiment at a time. Take the previous experiment off before adding the next, unless the game already needed it.

- `gamemoderun %command%` asks the `gamemode` daemon for a performance profile for that process.
- `mangohud %command%` draws the overlay from `~/.config/MangoHud/MangoHud.conf`. F12 toggles it. This shows whether frames are being produced when the window looks frozen.
- `gamescope -W 1920 -H 1080 -f -- %command%` runs the game in a fullscreen Gamescope session at that size. Change the width and height to the display. Other flags are in the Gamescope README.

`mangohud gamemoderun %command%` is the combination once each one has been tried on its own.

## GPU drivers

A 64-bit game needs the matching Vulkan driver. `nvidia-smi` is the check on NVIDIA. On Intel and AMD, the game's Proton log is the check: a line about a missing Vulkan ICD means the driver stack is incomplete.

32-bit games also need the lib32 driver. Omarchy's Steam install action is `omarchy-install-gaming-steam`. It installs Steam and then `omarchy-install-gaming-gpu-lib32`, which adds `lib32-vulkan-intel`, `lib32-vulkan-radeon`, or a lib32 NVIDIA package for the GPUs it finds. Heroic's action, `omarchy-install-gaming-heroic`, calls the same lib32 step. Install those from Install → Gaming before chasing Proton versions for a game that has never had a driver.

This bundle's `lib32-gamemode` and `lib32-mangohud` are the 32-bit halves of GameMode and MangoHud. They are not a substitute for the GPU's lib32 Vulkan driver.
