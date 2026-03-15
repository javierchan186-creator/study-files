#!/usr/bin/env bash
# sort_files.sh — Organizes files in the repository into the correct folders
# based on their file extension.
#
# Usage:
#   ./scripts/sort_files.sh [source_dir]
#
# If source_dir is not provided, the current directory is used.
# Supported mappings:
#   .md  .txt  .pdf  .doc  .docx                             → notes/
#   .py  .js  .ts  .java  .c  .cpp  .h  .hpp  .sh  .rb
#   .go  .rs  .swift  .kt                                    → exercises/
#   .png .jpg .jpeg .gif .svg .mp4 .mp3 .zip .tar .gz        → resources/
# Files that are already inside a known folder are left untouched.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${1:-$REPO_ROOT}"

NOTES_DIR="$REPO_ROOT/notes"
EXERCISES_DIR="$REPO_ROOT/exercises"
RESOURCES_DIR="$REPO_ROOT/resources"
PROJECTS_DIR="$REPO_ROOT/projects"

# Directories that should not be traversed for loose files
MANAGED_DIRS=("notes" "exercises" "resources" "projects" "scripts" ".git")

is_managed() {
  local file="$1"
  for dir in "${MANAGED_DIRS[@]}"; do
    if [[ "$file" == "$REPO_ROOT/$dir"* ]]; then
      return 0
    fi
  done
  return 1
}

move_file() {
  local src="$1"
  local dest_dir="$2"
  local filename
  filename="$(basename "$src")"
  local dest="$dest_dir/$filename"

  # Avoid overwriting existing files
  if [[ -e "$dest" ]]; then
    local base="${filename%.*}"
    local ext="${filename##*.}"
    local counter=1
    while [[ -e "$dest_dir/${base}_${counter}.${ext}" ]]; do
      counter=$((counter + 1))
    done
    dest="$dest_dir/${base}_${counter}.${ext}"
  fi

  echo "Moving: $src  →  $dest"
  mv "$src" "$dest"
}

echo "Sorting files in: $SOURCE_DIR"
echo "Repository root:  $REPO_ROOT"
echo "---"

find "$SOURCE_DIR" -maxdepth 1 -type f | sort | while read -r file; do
  # Skip files that belong to a managed directory
  is_managed "$file" && continue

  # Skip hidden files, this script itself, and the README
  filename="$(basename "$file")"
  [[ "$filename" == .* ]] && continue
  [[ "$file" == "${BASH_SOURCE[0]}" ]] && continue
  [[ "$filename" == "README.md" ]] && continue

  ext="${filename##*.}"
  ext="${ext,,}"  # lowercase

  case "$ext" in
    md|txt|pdf|doc|docx)
      move_file "$file" "$NOTES_DIR"
      ;;
    py|js|ts|java|c|cpp|h|hpp|sh|rb|go|rs|swift|kt)
      move_file "$file" "$EXERCISES_DIR"
      ;;
    png|jpg|jpeg|gif|svg|mp4|mp3|zip|tar|gz)
      move_file "$file" "$RESOURCES_DIR"
      ;;
    *)
      echo "Skipping (unknown type): $file"
      ;;
  esac
done

echo "---"
echo "Done."
