# AUR packages

`scripts/check-packages.sh` prints the live maintainer, vote count, out-of-date flag, and how many AUR packages that maintainer has. This file records why the official repositories were not enough.

| Package | Bundle | Maintainer | Why no official package works |
| --- | --- | --- | --- |
| `obs-pipewire-audio-capture` | creator | Freso, with co-maintainer tytan652 | OBS Studio 32.2.2 in `extra` has no per-application PipeWire capture. The matching upstream change, [obsproject/obs-studio#6207](https://github.com/obsproject/obs-studio/pull/6207), is still open. The package builds that plugin. Freso maintains it; tytan652, a main OBS packager on the AUR, is a co-maintainer. |
