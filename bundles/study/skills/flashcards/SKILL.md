---
name: flashcards
description: Make Anki cards from course notes as a CSV Anki can import, one fact per card, with cloze deletions where a sentence is the cue.
---

# Flashcards

Use this when a course folder has notes worth remembering. Write `flashcards/<topic>.csv` for Anki's File → Import. Leave Anki's collection file alone.

The card rules are original. These public skills were the model, and their text is not copied here:

- [doasfrancisco/anki-skill](https://github.com/doasfrancisco/anki-skill/blob/master/SKILL.md), for one fact per card and a short front
- [terkelg/anki-markdown](https://github.com/terkelg/anki-markdown/blob/main/skills/anki/SKILL.md), for cloze notes
- [maaarcooo/claude-skills, anki-flashcard-generator](https://github.com/maaarcooo/claude-skills/blob/main/anki-flashcard-generator/SKILL.md), for an importable question and answer file

## One fact

Each card holds one fact. If the back would contain "and" between two claims, make two cards. The front is a question with one answer, or a sentence with one deletion. Take the fact from `notes/`. Skip a card when the notes do not state it.

## CSV

Basic cards:

```csv
Front,Back,Tags
What is the unit of resistance?,ohm,physics
```

Quote a field that contains a comma. Tags are a single field, with words separated by spaces. The deck name is the course name from `syllabus.md`. Put that name in the instructions you give the student. The CSV itself has no deck column. Anki asks for the deck at import time.

## Cloze

Use a cloze when the sentence around the fact is the cue. Hide one term:

```csv
Text,Tags
The unit of resistance is {{c1::ohm}}.,physics
```

On import, choose the Cloze note type and map `Text` to the cloze field. A second important term in the same sentence is a second row, with its own `{{c1::...}}`. The same cloze number on one row hides every match on one card. Use that only when the matches are the same fact.

Import from Anki with File → Import, the course deck, and the note type that matches the header. The omanki bar plugin keeps a separate deck in `~/.local/share/omanki/cards.json`. A CSV row does not show up there until someone copies the fact into that file.
