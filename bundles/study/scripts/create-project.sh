#!/bin/bash

# Runs only from `omarchy bundle project new`, after that command has shown
# this file and you have confirmed. Safe to run again. It writes files under
# ~/School and does not download anything.

set -euo pipefail

ask() {
  local prompt="$1"
  if [[ -t 0 && -t 1 ]]; then
    gum confirm "$prompt"
    return
  fi
  return 1
}

read_value() {
  local prompt="$1" placeholder="$2" fallback="$3" value line
  if [[ -t 0 && -t 1 ]]; then
    value=$(gum input --prompt "$prompt" --placeholder "$placeholder" --value "$fallback")
    printf '%s\n' "$value"
    return
  fi
  IFS= read -r line || true
  if [[ -n $line ]]; then
    printf '%s\n' "$line"
  else
    printf '%s\n' "$fallback"
  fi
}

slug_for() {
  local raw="$1" slug
  slug=${raw,,}
  slug=${slug//[^[:alnum:]]/-}
  while [[ $slug == *--* ]]; do
    slug=${slug//--/-}
  done
  slug=${slug#-}
  slug=${slug%-}
  printf '%s\n' "$slug"
}

default_term() {
  local month year season
  month=$((10#$(date +%m)))
  year=$(date +%Y)
  if (( month >= 3 && month <= 5 )); then
    season=Spring
  elif (( month >= 6 && month <= 8 )); then
    season=Summer
  elif (( month >= 9 && month <= 11 )); then
    season=Fall
  else
    season=Winter
  fi
  printf '%s %s\n' "$season" "$year"
}

write_once() {
  local dest="$1"
  if [[ -e $dest ]]; then
    return
  fi
  mkdir -p -- "$(dirname -- "$dest")"
  cat >"$dest"
}

default=$(default_term)
term=$(read_value "Term: " "$default" "$default")
course=$(read_value "Course: " "cs101" "")
[[ -n $course ]] || {
  echo "A course code or name is required." >&2
  exit 1
}

term_slug=$(slug_for "$term")
course_slug=$(slug_for "$course")
[[ -n $term_slug && -n $course_slug ]] || {
  echo "The term and course did not produce folder names." >&2
  exit 1
}

dest="${HOME}/School/${term_slug}/${course_slug}"
mkdir -p -- "$dest/notes" "$dest/lectures" "$dest/readings" "$dest/assignments" "$dest/flashcards"

typst_course=${course//\\/\\\\}
typst_course=${typst_course//\"/\\\"}

write_once "$dest/syllabus.md" <<EOF
# ${course}

Term: ${term}

## Instructor

## Meeting times

## Goals

## Weekly plan

## Grading
EOF

write_once "$dest/assignments/assignment.typ" <<EOF
#set document(title: "${typst_course}", author: "Your name")
#set page(margin: 1in)
#set text(size: 11pt)

= Assignment title

Replace this paragraph. Cite a source from refs.bib as @example.

#bibliography("refs.bib", style: "ieee")
EOF

write_once "$dest/assignments/refs.bib" <<'EOF'
@misc{example,
  title = {Replace this entry with a Zotero export},
  author = {Student},
  year = {2026}
}
EOF

if ask "Create a minimal Obsidian vault in notes/?"; then
  vault="$dest/notes/.obsidian"
  mkdir -p -- "$vault"
  write_once "$vault/app.json" <<'EOF'
{}
EOF
  write_once "$vault/core-plugins.json" <<'EOF'
[
  "file-explorer",
  "global-search",
  "switcher",
  "graph",
  "backlink",
  "tag-pane",
  "daily-notes",
  "templates",
  "command-palette",
  "editor-status",
  "word-count"
]
EOF
  write_once "$vault/daily-notes.json" <<'EOF'
{
  "format": "YYYY-MM-DD",
  "folder": ""
}
EOF
  write_once "$dest/notes/index.md" <<EOF
# ${course}

Daily notes land in this folder. The Obsidian Daily bar plugin reads \`.obsidian/daily-notes.json\` and needs this vault's path in its settings.
EOF
  echo "Obsidian vault: $dest/notes"
else
  echo "Left notes/ as a plain folder."
fi

cat <<EOF
Anki keeps decks in its own collection. This script leaves that collection alone.
To make a deck for this course:
  1. Open Anki.
  2. Create a deck named "${course}".
  3. When flashcards/ has a CSV, use File → Import.
     A basic card has the header Front,Back,Tags.
     A cloze card puts {{c1::answer}} in the text field and uses the Cloze note type.
EOF

printf 'Created %s\n' "$dest"
