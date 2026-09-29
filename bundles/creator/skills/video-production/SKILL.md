---
name: video-production
description: Plan a screencast or stream, check the recording setup, name the raw files, and open the Kdenlive project against raw/.
---

# Video production

Use this when starting or recording a project created by the creator bundle. The project folder is `~/Videos/Projects/<YYYY-MM-DD>-<slug>/`.

## Plan

Write the plan in `script/outline.md` before recording.

- Outline: the sections, in order, and what the viewer should understand at the end of each.
- Script: the words to say. Short lines. Mark where the screen changes.
- Shot list: one line per shot, with what is on screen and about how long it runs.

## Recording checklist

- Audio: talk once and watch the level. Speech should sit well under clipping. Silence the apps that are not part of the video. For a single application's sound in OBS, add an Application Audio Capture (PipeWire) source from `obs-pipewire-audio-capture`. Easy Effects and Omavoice are for the microphone, not for the desktop mix.
- OBS: one scene for the screen, one for the camera if you need it. Confirm the canvas matches the screen you are recording.
- Resolution: record the screen at the size you will publish, or at an even multiple of it. Do not crop a 4K grab down to a corner in the edit if you can record the window.
- Destination: source `project.env` in the shell that starts a recording so `OMARCHY_SCREENRECORD_DIR` points at this project's `raw/`. That variable is how Omarchy's screen recorder chooses its folder, and the folder must already exist. Do not write the variable into a global config.
- Virtual camera: only if this project needs one. Loading `v4l2loopback` asks for sudo.

## Raw files

Put captures in `raw/` and name them `<YYYY-MM-DD>-<scene>-<take>.ext`, for example `raw/2026-09-28-intro-01.mp4`. Keep the date, the scene slug, and the take number in that order so a directory listing is the shot list. Do not rename a file after it is on the Kdenlive timeline.

## Kdenlive

Follow `edit/kdenlive.md`. The project folder inside Kdenlive is `raw/`. Save the `.kdenlive` file in `edit/`. Put exports in `export/` and leave `raw/` untouched.
