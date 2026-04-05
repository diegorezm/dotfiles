#!/bin/bash

CURRENT_DIR=$(pwd)
HOME_DIR=$HOME

create_symlink() {
    local src=$1
    local dest=$2

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        echo "SKIP (already symlinked): $dest"
    elif [ -e "$dest" ]; then
        echo "SKIP (file exists): $dest"
    else
        ln -s "$src" "$dest"
        echo "LINKED: $dest -> $src"
    fi
}

# Walk through all files and directories tracked by git (respects .gitignore)
while IFS= read -r -d '' file; do
    # Get the relative path from CURRENT_DIR
    rel="${file#$CURRENT_DIR/}"

    # Skip the script itself and git internals
    [[ "$rel" == .git* ]] && continue
    [[ "$rel" == "$(basename "$0")" ]] && continue

    create_symlink "$file" "$HOME_DIR/$rel"
done < <(find "$CURRENT_DIR" -mindepth 1 \
    -not -path '*/.git/*' \
    -not -name '.git' \
    -not -name "$(basename "$0")" \
    -print0)
