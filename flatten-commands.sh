#!/bin/bash

# Flatten Commands Script
# Creates a flat structure from nested commands directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/commands"
TARGET_DIR="$SCRIPT_DIR/commands-flat"

echo "Flattening commands..."

# Clean target directory
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Copy and flatten
shopt -s globstar
cd "$SOURCE_DIR"
for file in **/*.md; do
    if [ -f "$file" ]; then
        # Replace / with - in the path
        flat_name="${file//\//-}"
        cp "$file" "$TARGET_DIR/$flat_name"
    fi
done

echo "Done! Flattened $(ls -1 "$TARGET_DIR"/*.md 2>/dev/null | wc -l) commands"
