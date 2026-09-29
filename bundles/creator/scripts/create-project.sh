#!/bin/bash

# Runs only from `omarchy bundle project new`, after that command has shown
# this file and you have confirmed. Safe to run again. It does not edit
# Omarchy's global config.

set -euo pipefail

ask() {
  local prompt="$1"
  if [[ -t 0 && -t 1 ]]; then
    gum confirm "$prompt"
    return
  fi
  return 1
}

read_title() {
  if [[ -t 0 && -t 1 ]]; then
    gum input --prompt "Video title: " --placeholder "Desk tour"
  else
    local line
    IFS= read -r line || true
    printf '%s\n' "$line"
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

title=$(read_title)
[[ -n $title ]] || {
  echo "A title is required." >&2
  exit 1
}
slug=$(slug_for "$title")
[[ -n $slug ]] || {
  echo "The title did not produce a folder name." >&2
  exit 1
}

stamp=$(date +%F)
dest="${HOME}/Videos/Projects/${stamp}-${slug}"
mkdir -p -- "$dest/script" "$dest/raw" "$dest/assets" "$dest/edit" "$dest/export"

if [[ ! -f $dest/script/outline.md ]]; then
  cat >"$dest/script/outline.md" <<EOF
# ${title}

## Outline

## Script

## Shot list
EOF
fi

if [[ ! -f $dest/publish.md ]]; then
  cat >"$dest/publish.md" <<EOF
# ${title}

## Title

## Description

## Chapters

## Tags

## Thumbnail brief
EOF
fi

if [[ ! -f $dest/edit/kdenlive.md ]]; then
  cat >"$dest/edit/kdenlive.md" <<EOF
# Kdenlive

This folder does not contain a generated .kdenlive file. Kdenlive's project
XML changes between releases, and a file written here would not reliably open
with its capture folder set to raw/.

1. Open Kdenlive.
2. Create a project and save it in this edit/ folder.
3. In Project Settings, set the project folder to:

   ${dest}/raw

4. Import clips from that raw/ folder. Export finished files to:

   ${dest}/export
EOF
fi

if [[ ! -f $dest/project.env ]]; then
  printf 'OMARCHY_SCREENRECORD_DIR=%q\n' "$dest/raw" >"$dest/project.env"
fi

if ask "Load v4l2loopback so OBS can use a virtual camera? This runs sudo modprobe v4l2loopback."; then
  sudo modprobe v4l2loopback
fi

printf 'Created %s\n' "$dest"
