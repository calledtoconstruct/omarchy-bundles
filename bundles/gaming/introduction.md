# Gaming

This bundle sets up a PC game session on Omarchy. It installs the performance tools and the overlay, then the bar plugins that launch games and quiet the desktop. There is **no project folder** and no launcher sequence. You start a game from Steam, Heroic, or GameDock.

> Steam and Heroic stay on **Install → Gaming**. Those menu installers also add the 32-bit Vulkan driver for your GPU. This bundle does not.

## What was installed

| Tool | Command or app | What it is for |
| --- | --- | --- |
| GameMode | `gamemoderun` | A per-game performance profile from Feral |
| MangoHud | `mangohud` | FPS, frametime, and CPU/GPU load |
| Gamescope | `gamescope` | A nested or fullscreen game session |
| Goverlay | Goverlay in the app launcher | A GUI for the MangoHud config |
| ProtonUp-Qt | ProtonUp-Qt in the app launcher | GE-Proton and other compatibility tools |
| `lib32-gamemode`, `lib32-mangohud` | — | The same two tools for 32-bit games |

ProtonUp-Qt is the AUR package. Upstream also publishes a Flatpak, `net.davidotek.pupgui2`, if you would rather use that.

## Play a game with the overlay

1. Install Steam or Heroic from **Install → Gaming** if you have not already.
2. Open ProtonUp-Qt, install one GE-Proton build, and **restart Steam** so it appears in the compatibility list. Pick it for one game.
3. Set that game's launch options to:

```
mangohud gamemoderun %command%
```

Try each wrapper on its own before combining them. `mangohud %command%` draws the overlay. `gamemoderun %command%` asks the GameMode daemon for a performance profile for that process.

The overlay sits in the **top-left**. It shows FPS, frametime, CPU load and temperature, and GPU load and temperature. **F12** shows or hides it. The config is `~/.config/MangoHud/MangoHud.conf`. Goverlay edits that same file. If the file was already yours, install left it in place.

`lib32-gamemode` and `lib32-mangohud` are not a substitute for the GPU's 32-bit Vulkan driver. The Steam and Heroic installers add that driver.

## The bar

If you enabled the plugins, three icons land on the **right** side of the bar.

- **Game Mode** is the gamepad chip. A click hides the bar, silences notifications, turns night light off, and switches the power profile to performance. Most Super shortcuts and Alt+Tab are locked so they do not steal input. Super+1 through Super+10, and Super+C/V/X, stay available. **Super+Ctrl+G** leaves Game Mode. Right-click the chip for settings. Starting Steam in Gamescope is off until you turn that setting on. This chip is separate from `gamemoderun`.
- **GameDock** is the controller icon. Its panel lists launchers and installed games from Steam, Heroic, RetroArch, and RPCS3. With none of those installed, the panel is empty.
- **Discord** is a Discord mark. It stays dim while Discord is not running, turns the theme's urgent color on a mention or DM, and grows a dot during a voice call. This bundle does not install Discord. The Arch `discord` package and Vesktop are the clients it understands. Hide Discord's own tray icon (right-click the tray, **Manage**, untick Discord) or you get two icons.

Leave the plugins disabled and the bar stays as it was. Enable them later with:

```
omarchy plugin enable silvaio.gamemode
omarchy plugin enable io.github.prathamesh913.gamedock
omarchy plugin enable io.github.thisisgm.discord
```

## When a game will not start

Ask an agent to use the **proton-troubleshooter** skill, linked as `gaming-proton-troubleshooter`. It walks through ProtonDB, another Proton or GE-Proton build, the Proton log, launch options, and the GPU driver.
