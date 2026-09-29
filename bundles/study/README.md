# Study

For students and self-learners. One install adds Anki, Typst, Pandoc, Zathura, Harper, and Zotero, plus four bar plugins and three agent skills. A course lives at `~/School/<term>/<course>/`. The install notification opens `introduction.md`.

## What it installs

| Package | Repository | Why it is listed |
| --- | --- | --- |
| `anki` | extra | Decks and review. The create script prints the steps to add a deck. It does not write Anki's collection |
| `typst` | extra | Assignments in `assignments/` |
| `pandoc-cli` | extra | Turn a Word or Markdown draft into something Typst can sit beside |
| `zathura` | extra | Read PDFs in `readings/` |
| `zathura-pdf-mupdf` | extra | The PDF backend Zathura uses for those readings |
| `harper` | extra | Grammar and spelling while writing |
| `zotero-bin` | AUR | The official Zotero Linux build. There is no `zotero` package in core, extra, or multilib |

`zotero-bin` 10.0.3-1 is maintained by juanmah, whose only AUR package is this one. On 2026-09-28 it had 462 votes and was not flagged out of date. Its PKGBUILD sets `source_x86_64` (and the i686 and aarch64 equivalents) to `https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=${pkgver}`, and it sets `sha256sums` for the desktop file plus `sha256sums_x86_64`, `sha256sums_i686`, and `sha256sums_aarch64`. It `provides` and `conflicts` with `zotero`. The AUR package `zotero`, maintained by agkphysics, is the source build of the same app. Pacman will not install both. This bundle installs `zotero-bin`. See [AUR-PACKAGES.md](../../AUR-PACKAGES.md) and [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

Zotero is also on Flathub as `org.zotero.Zotero` for anyone who would rather install that than `zotero-bin`.

Already in Omarchy, so they are not in `packages`:

- Obsidian (`obsidian`)
- Xournal++ (`xournalpp`)
- LibreOffice (`libreoffice-fresh`)

## Plugins

Each URL was checked against `omarchy-plugin-validate`. The schema cannot store a commit, so the reviewed revisions are written here. See [SCHEMA-GAPS.md](../../SCHEMA-GAPS.md).

| Plugin | Id | Reviewed commit | What it adds |
| --- | --- | --- | --- |
| [yamz8/omanki](https://github.com/yamz8/omanki) | `yamz8.omanki` | `3b7f0f1075233b8531492f5186080ccc7395774f` | Spaced repetition in the bar, scheduled the way Anki schedules cards, with a due count. The deck is `~/.local/share/omanki/cards.json`. It does not read Anki's collection |
| [TyRichards/omarchy-clarity](https://github.com/TyRichards/omarchy-clarity) | `io.github.tyrichards.clarity` | `ff99f62868dacc5e6ba04a8cd71a8d3a48f6d816` | Distraction blocking and up to three daily focus windows. Turning the block off asks for a Clarity password |
| [pjgeutjens/omarchy-clockwork](https://github.com/pjgeutjens/omarchy-clockwork) | `io.github.pjgeutjens.clockwork` | `afaa28a80e884f93ff4279724d2170776da24bfe` | Stopwatch, countdown, alarm, intervals, and a Pomodoro cycle in the bar. Release 0.7.1, last commit 2026-09-10 |
| [LucaNerlich/obsidian-daily-qs](https://github.com/LucaNerlich/obsidian-daily-qs) | `luca.obsidian-daily` | `5125055128d2b9cd30bb6957a094a4f1fc1471a5` | Today's Obsidian daily note in the bar: open items, new checkboxes, and toggles. It needs the vault path in the widget settings, or `OBSIDIAN_VAULT_ROOT` |

Clockwork is the Pomodoro plugin in this bundle. [Pnkm0nK/Omodoro](https://github.com/Pnkm0nK/Omodoro) is a Pomodoro and task list whose last commit was 2026-08-30. Clockwork's last commit is 2026-09-10, and it ships a version number, so it is the one included.

omanki and Anki both use spaced repetition. omanki reviews its own JSON deck from the bar. Anki is the desktop app the flashcards skill imports into.

## Project layout

`omarchy bundle project new study <name>` creates `~/School/<name>/{notes,lectures,readings,assignments,flashcards}` and `.omarchy-project`, then shows `scripts/create-project.sh` and asks before running it.

The manifest cannot build `<term>/<course>` from two answers. The script asks for both and creates `~/School/<term-slug>/<course-slug>/` with those five folders. `project.root` stays `~/School`. The season in the default term is Spring for March through May, Summer for June through August, Fall for September through November, and Winter otherwise, plus the calendar year.

The script is safe to run again. It writes a file only when that file is missing.

1. Term, then course code or name. On a terminal, gum pre-fills the term. Without a terminal, the first stdin line is the term and a blank line keeps the default. The second line is the course. An empty course exits with an error.
2. `syllabus.md`, `assignments/assignment.typ`, and `assignments/refs.bib`.
3. It offers a minimal Obsidian vault in `notes/.obsidian`, with the daily notes core plugin enabled and notes stored in `notes/` itself. Declining leaves `notes/` as a plain folder.
4. It prints how to create an Anki deck named after the course and how to import `flashcards/*.csv`. Anki's collection stays untouched, because writing it while Anki may have the file open is not a safe script.

Without a terminal, every confirm is treated as no. The script still creates the course folder and the templates. It does not call the network, Obsidian, Anki, Typst, or Zotero.

`printf '\nCS 101\n' | ./scripts/create-project.sh` uses the default term and the course `CS 101`.

## Launcher

There is no launcher field in `bundle.json`. This is the flow to use after a course folder exists. A Quickshell button for it is later work.

1. Open Obsidian on `notes/`. When the create script made the vault, that folder is the vault. The Obsidian Daily plugin reads today's note from there once the vault path is set.
2. Open a PDF in `readings/` with `zathura`.
3. Edit Typst in `assignments/` and compile with `typst compile assignment.typ`.
4. Open Anki and review the deck named for the course.

Xournal++ and LibreOffice are already on the machine for handwritten notes and office files.

## Conflicts

None with other bundles. `zotero-bin` conflicts with the AUR package `zotero`. This bundle installs `zotero-bin`.
