# AUR packages

`scripts/check-packages.sh` prints the live maintainer, vote count, out-of-date flag, and how many AUR packages that maintainer has. This file records why the official repositories were not enough.

| Package | Bundle | Maintainer | Why no official package works |
| --- | --- | --- | --- |
| `obs-pipewire-audio-capture` | creator | Freso, with co-maintainer tytan652 | OBS Studio 32.2.2 in `extra` has no per-application PipeWire capture. The matching upstream change, [obsproject/obs-studio#6207](https://github.com/obsproject/obs-studio/pull/6207), is still open. The package builds that plugin. Freso maintains it; tytan652, a main OBS packager on the AUR, is a co-maintainer. |
| `zotero-bin` | study | juanmah | No `zotero` package exists in core, extra, or multilib. `zotero-bin` 10.0.3-1 repackages Zotero's Linux tarball. The PKGBUILD points `source_x86_64`, `source_i686`, and `source_aarch64` at `https://www.zotero.org/download/client/dl` with `channel=release` and `version=${pkgver}`, and it sets `sha256sums` plus a per-architecture `sha256sums_*`. juanmah maintains this one AUR package. On 2026-09-28 it had 462 votes and was not flagged out of date. It `conflicts` with `zotero`, the AUR source build. |
