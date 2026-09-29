# Gaming

For PC games on Omarchy. One install adds GameMode, MangoHud, Gamescope, Goverlay, and ProtonUp-Qt, plus three bar plugins, one agent skill, and a MangoHud config. There is no project layout. The install notification opens `introduction.md`. A bundle without `project` has nothing for `omarchy bundle project new` to create, and it has no launcher sequence. You install it, then start games from Steam, Heroic, or GameDock.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `gamemode` | extra | `gamemoderun` for a per-game performance profile |
| `mangohud` | extra | The FPS overlay. The config template is `~/.config/MangoHud/MangoHud.conf` |
| `gamescope` | extra | A nested or fullscreen game session |
| `goverlay` | extra | A GUI for the same MangoHud config |
| `lib32-gamemode` | multilib | GameMode for 32-bit games |
| `lib32-mangohud` | multilib | MangoHud for 32-bit games |
| `protonup-qt` | AUR | Installs GE-Proton and other compatibility tools |

`protonup-qt` 2.15.1-1 is maintained by yochananmarqos, who had 565 AUR packages on 2026-09-28. The package had 118 votes and was not flagged out of date. Upstream also publishes a Flathub build, `net.davidotek.pupgui2`, for anyone who would rather install that than the AUR package. See [AUR-PACKAGES.md](../../AUR-PACKAGES.md).

Steam and Heroic are Omarchy installers, not lines in `packages`. A flat package list cannot express the GPU choice those installers make.

Install → Gaming → Steam runs `omarchy-install-gaming-steam`. That installs `steam`, then `omarchy-install-gaming-gpu-lib32`. The lib32 step adds `lib32-vulkan-intel` when it sees Intel, `lib32-vulkan-radeon` when it sees AMD, `lib32-nvidia-utils` for a current NVIDIA GPU, and `lib32-nvidia-580xx-utils` for an older NVIDIA GPU.

Install → Gaming → Heroic runs `omarchy-install-gaming-heroic`. That installs `heroic-games-launcher-bin` and calls the same lib32 step. `heroic` is not an official package name.

Install both from the menu before the first game that needs 32-bit Vulkan. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

## Plugins

Each URL was checked against `omarchy-plugin-validate`. The schema cannot store a commit, so the reviewed revisions are written here.

| Plugin | Id | Reviewed commit | What it adds |
| --- | --- | --- | --- |
| [silvaio/gamemode-switcher](https://github.com/silvaio/gamemode-switcher) | `silvaio.gamemode` | `4a9b2b82c6ad0991da702a11a98f19a1b9c8ed18` | A Game Mode chip. It hides the bar, switches Hyprland into its own submap, sets the performance power profile with `powerprofilesctl`, and can start Steam in Gamescope or Big Picture. This is separate from Feral `gamemoderun` |
| [Prathamesh913/gamedock](https://github.com/Prathamesh913/gamedock) | `io.github.prathamesh913.gamedock` | `40de6e016f9872afb895aa090ad34a495af17b2a` | A bar panel that browses and launches games from Steam, Heroic, RetroArch, and RPCS3. Last push 2026-09-09 |
| [thisisgm/omarchy-discord](https://github.com/thisisgm/omarchy-discord) | `io.github.thisisgm.discord` | `08e0bf89a96d0b5d923aa207d914a349ce4d5eaf` | Discord in the bar: attention, whether a call is up, call quality, mic mute, and the process's memory |

[sir-francisdrake/game-launcher](https://github.com/sir-francisdrake/game-launcher) validated (`io.github.sir-francisdrake.game-launcher`, `20ea0409e7c29e063c796dd800475c7ebc171a48`). It is another library panel, for Steam, Lutris, Heroic, Bottles, and Flatpak, and its last push was 2026-08-22. GameDock is the launcher this bundle ships. One panel is enough.

## Config

`config/MangoHud.conf` is copied to `~/.config/MangoHud/MangoHud.conf` when that file is absent. The overlay shows FPS, frametime, CPU load and temperature, and GPU load and temperature, in the top-left. F12 toggles it.

A file that already exists is yours. Install leaves it in place. Remove drops this bundle's ownership and leaves the file. Goverlay edits the same path, so a config you saved there stays.

## No launcher

`bundle.json` has no `project`. There is no project script and no launcher sequence to document. After install, open Steam or Heroic from the menu, or use the GameDock panel. The proton-troubleshooter skill is for a game that does not start.

## Conflicts

None with other bundles.
