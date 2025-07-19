#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

symlinkFile() {
    filename="$SCRIPT_DIR/$1"
    destination="$HOME/$2/$1"

    mkdir -p $(dirname "$destination")
    
    if [ ! -L "$destination" ]; then
        if [ -e "$destination" ]; then
            echo "[ERROR] $destination exists but it's not a symlink. Please fix that manually" && exit 1
        else
            ln -s "$filename" "$destination"
            echo "[OK] $filename -> $destination"
        fi
    else
        echo "[WARNING] $filename already symlinked"
    fi
}

deployManifest() {
    while IFS='|' read -r filename operation destination; do
        case $operation in
            symlink)
                symlinkFile "$filename" "$destination"
                ;;
            *)
                echo "[WARNING] Unknown operation $operation. Skipping..."
                ;;
        esac
    done < "$SCRIPT_DIR/$1"
}

echo "--- Common configs ---"
deployManifest MANIFEST
echo "--- Linux configs ---"
deployManifest MANIFEST.linux