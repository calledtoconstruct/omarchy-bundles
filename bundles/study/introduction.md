# Study

This bundle is for a course, whether you are enrolled or teaching yourself. It installs the reading and writing tools, four bar plugins, and three agent skills. A course lives at `~/School/<term>/<course>/`.

## What was installed

| Package | Where | What it is for |
| --- | --- | --- |
| `anki` | extra | Decks and review |
| `typst` | extra | Assignments |
| `pandoc-cli` | extra | Turn a Word or Markdown draft into something Typst can sit beside |
| `zathura` | extra | Read PDFs |
| `zathura-pdf-mupdf` | extra | The PDF backend Zathura uses |
| `harper` | extra | Grammar and spelling while you write |
| `zotero-bin` | AUR | Zotero, the official Linux build |

Zotero is also on Flathub as `org.zotero.Zotero` if you would rather use that than the AUR package. Pacman will not install `zotero-bin` beside the source package named `zotero`.

Open **Anki**, **Zotero**, and **Zathura** from the app launcher. `typst`, `pandoc`, and `harper` are commands.

## A course folder

```
omarchy bundle project new study cs101
```

That creates the course directory and, after you confirm the script, a syllabus, an assignment in Typst, and a bibliography. Two things the script will **not** do:

- It does not write Anki's collection. It prints how to create a deck and import a CSV.
- It does not open an Obsidian vault unless you are at a terminal and choose to.

Readings go in `readings/` and open in Zathura. Assignments go in `assignments/`.

## The bar

If you enabled the plugins:

| Icon | What it shows |
| --- | --- |
| Review | A due count, scheduled the way Anki schedules cards. The deck is `~/.local/share/omanki/cards.json`. It does **not** read Anki's collection |
| Focus | Distraction blocking and up to three daily focus windows. Turning the block off asks for a Clarity password |
| Timer | Stopwatch, countdown, alarm, intervals, and a Pomodoro cycle |
| Daily note | Today's Obsidian note: open items, new checkboxes, and toggles |

> The daily-note widget needs the vault path in its settings, or `OBSIDIAN_VAULT_ROOT`. Until that is set, it has nothing to open.

## Skills

Three agent skills are linked where an agent skill directory already exists:

1. **course-notes** turns a lecture transcript or rough notes into a summary, key terms, and practice questions in the course folder.
2. **flashcards** writes Anki cards as a CSV, one fact per card.
3. **research-papers** finds and cites sources in Zotero, then writes an assignment in Typst with a bibliography exported from that library.

Point the agent at the course folder and name the skill.
