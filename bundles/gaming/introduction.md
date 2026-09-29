# Gaming

GameMode, MangoHud, Gamescope, Goverlay, and ProtonUp-Qt are installed. There is no project folder.

In a game's launch options, `mangohud %command%` draws FPS, frametime, and CPU and GPU load in the top-left. F12 shows or hides it. `gamemoderun %command%` asks GameMode for a performance profile. Goverlay edits the same file, `~/.config/MangoHud/MangoHud.conf`.

ProtonUp-Qt installs GE-Proton and other compatibility tools. Restart Steam before a new version appears in a game's compatibility list.

If you enabled the plugins, the right side of the bar has three new icons. Game Mode is the gamepad: a click hides the bar, locks most Hyprland shortcuts, and switches to the performance profile. Super+Ctrl+G leaves Game Mode. GameDock is the controller icon and lists games from Steam, Heroic, RetroArch, and RPCS3. Discord is a mark for the Discord desktop app. This bundle does not install Discord.

Steam and Heroic are still under Install → Gaming. Those installers also add the 32-bit Vulkan driver for your GPU. `lib32-gamemode` and `lib32-mangohud` are only the 32-bit halves of GameMode and MangoHud.
