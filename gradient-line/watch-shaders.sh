#!/bin/bash

# Watch shader files and copy them to build directory on change
# Usage: ./watch-shaders.sh

BUILD_DIR="build/gradient-line"

echo "Watching shader files for changes..."
echo "Press Ctrl+C to stop"
echo ""

# Function to copy shaders
copy_shaders() {
    echo "[$(date '+%H:%M:%S')] Copying shaders..."
    mkdir -p "$BUILD_DIR"
    cp shader.vert "$BUILD_DIR/"
    cp shader.frag "$BUILD_DIR/"
    echo "[$(date '+%H:%M:%S')] ✓ Shaders copied! Press 'R' in the app to reload."
}

# Copy shaders initially
copy_shaders

# Watch for changes (works on macOS with fswatch, or Linux with inotifywait)
if command -v fswatch &> /dev/null; then
    # macOS
    fswatch -o shader.vert shader.frag | while read; do
        copy_shaders
    done
elif command -v inotifywait &> /dev/null; then
    # Linux
    while inotifywait -e modify shader.vert shader.frag; do
        copy_shaders
    done
else
    echo "Error: Neither fswatch (macOS) nor inotifywait (Linux) found."
    echo "Please install one of them:"
    echo "  macOS: brew install fswatch"
    echo "  Linux: apt-get install inotify-tools"
    exit 1
fi
