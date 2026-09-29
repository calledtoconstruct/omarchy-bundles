---
name: course-notes
description: Turn a lecture transcript or rough notes into a summary, key terms, and practice questions in the course notes folder.
---

# Course notes

Use this for a course folder created by the study bundle, `~/School/<term>/<course>/`. The source is a transcript or rough notes in `lectures/`. The result goes in `notes/`.

## Read the source

Open the lecture file the student names. If they paste a transcript into the chat, write that transcript to `lectures/<yyyy-mm-dd>-<topic>.md` first so the notes point at a file.

Stay inside what that source says. When a term is missing from the lecture, leave it out of the key terms instead of filling it from memory.

## Write the note

Create `notes/<yyyy-mm-dd>-<topic>.md`:

```markdown
# Topic

Source: lectures/<file>

## Summary

A short account of the lecture, in the order it was taught.

## Key terms

- **Term.** The definition as the lecture used it.

## Practice questions

1. A question a student can answer from the summary, with the answer on the next line.
```

One lecture, one notes file. Add a second file when the student brings a second lecture. Link the new note from `syllabus.md` under the weekly plan when that week is already listed.
