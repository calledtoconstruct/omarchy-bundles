# Creator

This bundle is for screencasts, YouTube videos, and streams. It adds the capture tools that are **not** already on a default Omarchy install, five bar plugins, two agent skills, and a dated project under `~/Videos/Projects`.

OBS Studio, Kdenlive, and GPU Screen Recorder were already part of Omarchy, so they are not in this bundle.

## What was installed

| Package | Where | What it is for |
| --- | --- | --- |
| `v4l2loopback-dkms` | extra | Kernel module for an OBS virtual camera |
| `v4l2loopback-utils` | extra | Userspace tools for that module |
| `easyeffects` | extra | Microphone processing |
| `audacity` | extra | A voice track outside the video timeline |
| `obs-pipewire-audio-capture` | AUR | One application's PipeWire audio inside OBS |

Open **EasyEffects** for the microphone and **Audacity** from the app launcher. In OBS, the PipeWire audio capture plugin is how you record a single application instead of the whole desktop mix.

## A project

Create a dated project with:

```
omarchy bundle project new creator my-video
```

The folder lands under `~/Videos/Projects` with these directories:

1. `script`
2. `raw`
3. `assets`
4. `edit`
5. `export`

The create script only runs after you have seen it and confirmed. Removing the bundle does not delete projects you already made.

## The bar

If you enabled the plugins, the bar can show:

- A **movable camera window** for a recording that does not need an OBS scene.
- A **webcam preview** and its V4L2 controls.
- **On-screen keystrokes** for a tutorial.
- **Input, output, and level** controls.
- A **virtual microphone** with noise and echo control for OBS, Zoom, and Meet.

> The virtual microphone is the one to pick in OBS or a call app when you want the cleaned signal. The webcam preview is a check that the camera is the one you think it is before you record.

Plugins you left disabled stay off. Enable a single one later with `omarchy plugin enable` and its id, for example `omarchy plugin enable io.github.kristoferlund.webcam`.

## Skills

Two agent skills are linked for the machines that already have an agent skill directory:

- **video-production** for the shape of a shoot and an edit.
- **publish** for getting a finished piece out.

Ask the agent for the skill by that job. It reads the linked `SKILL.md`. It does not run a file from the bundle on its own.
