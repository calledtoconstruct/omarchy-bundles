# Creator

For screencasters, YouTube videos, and streams on Omarchy. One install adds the capture packages that are not already on a default machine, five bar plugins, two agent skills, and a dated project under `~/Videos/Projects`. The install notification opens `introduction.md`.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `v4l2loopback-dkms` | extra | Kernel module for an OBS virtual camera |
| `v4l2loopback-utils` | extra | Userspace tools for that module |
| `easyeffects` | extra | Microphone processing |
| `audacity` | extra | Edit a voice track outside the video timeline |
| `obs-pipewire-audio-capture` | AUR | Per-application PipeWire audio inside OBS. See [AUR-PACKAGES.md](../../AUR-PACKAGES.md) |

Already in Omarchy, so they are not in `packages`:

- `obs-studio`
- `kdenlive`
- `gpu-screen-recorder`

`noise-suppression-for-voice` is in `extra` and is what [Omavoice](https://github.com/gigasolo/omavoice) asks for as its denoise engine. It is not part of this bundle. `obs-cmd` is not used.

### OBS already captures some audio, not this

`obs-studio` 32.2.2 in `extra` does not capture one application's audio on Linux. Its Application Audio Capture toolbar is the Windows WASAPI source (`win-wasapi`). The Linux PipeWire plugin in that release is camera and screencast portals. Upstream pull request [obsproject/obs-studio#6207](https://github.com/obsproject/obs-studio/pull/6207), which would add PipeWire device and application capture, is still open. `obs-pipewire-audio-capture` 1.2.1-1 stays until that lands in Arch. It is maintained by Freso, with tytan652 (a main OBS packager on the AUR) as a co-maintainer, and it was not flagged out of date when this bundle was added.

### obs-studio and obs-studio-browser

Omarchy ships `obs-studio` from `extra`. `obs-studio-browser` is an AUR build that conflicts with it. This bundle does not install the browser build. `conflicts` in `bundle.json` is a list of other bundle ids, not package names, so the package conflict is recorded here and in [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

## Plugins

Each URL was checked with `omarchy-plugin-validate`. The schema cannot store a commit, so the reviewed revisions are here.

| Plugin | Id | Reviewed commit | What it adds |
| --- | --- | --- | --- |
| [tomdavenport/cam-stream](https://github.com/tomdavenport/cam-stream) | `io.github.tomdavenport.cam-stream` | `4a04dafda97a22cf740fdd2c8999f2e5c82ba93f` | A movable camera window for a recording that does not need an OBS scene |
| [kristoferlund/omarchy-webcam](https://github.com/kristoferlund/omarchy-webcam) | `io.github.kristoferlund.webcam` | `6772b78318adc9d8e507ba2222285c2af682ded4` | A bar preview of the webcam and its V4L2 controls |
| [felixzsh/omarchy-key-visualizer](https://github.com/felixzsh/omarchy-key-visualizer) | `felixzsh.key-visualizer` | `1aadf9cfebce11252484b8de4e9c8ed8da6d89b5` | Keystrokes on screen for a tutorial |
| [ssupt/omarchy-audio-control](https://github.com/ssupt/omarchy-audio-control) | `ssupt.audio-control` | `f561410e70a71133e39744bcd9091dab184af11c` | Input, output, and level control from the bar |
| [gigasolo/omavoice](https://github.com/gigasolo/omavoice) | `gigasolo.omavoice` | `86ac9be415c07a25162a434956b5b87e64813831` | A virtual microphone with noise and echo control for OBS, Zoom, and Meet |

Cam Stream and the webcam plugin both involve a camera. Both stay. Cam Stream is the picture you put on a recording. The webcam plugin is the preview and the hardware controls.

## Project layout

`project.root` is `~/Videos/Projects`. The manifest cannot turn a title into `<YYYY-MM-DD>-<slug>`, so `scripts/create-project.sh` asks for the title and creates that folder itself, with `script/`, `raw/`, `assets/`, `edit/`, and `export/`.

The script writes:

- `script/outline.md` from a template (outline, script, shot list)
- `publish.md` with empty Title, Description, Chapters, Tags, and Thumbnail brief sections
- `edit/kdenlive.md` with the steps to create a Kdenlive project whose folder is `raw/`. A `.kdenlive` file is not generated; the XML is not stable enough to promise it will open
- `project.env`, containing only `OMARCHY_SCREENRECORD_DIR` set to that project's `raw/`. Source it in the shell that starts a recording. The script does not change global config

Loading `v4l2loopback` is a separate confirm, because it runs `sudo modprobe v4l2loopback`. Without a terminal, the title is the first line of stdin and that confirm is treated as no. `printf 'Desk tour\n' | ./scripts/create-project.sh` creates the dated folder, the templates, and `project.env`, and does not call sudo.

## Launcher

There is no launcher field in `bundle.json`. After a project exists:

1. Open `script/outline.md` in the editor.
2. Record with OBS, or with Omarchy's screen recorder after sourcing `project.env`, so the file lands in `raw/`.
3. Open Kdenlive and follow `edit/kdenlive.md`.
4. Fill `publish.md` before the upload.

## Conflicts

No other bundle. The `obs-studio` / `obs-studio-browser` package conflict is described above.
