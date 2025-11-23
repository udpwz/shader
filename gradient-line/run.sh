#!/bin/bash

# Build the project
echo "Building project..."
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Run the executable
echo "Starting application..."
echo "Press Ctrl+C to exit"
echo ""

cd build/gradient-line
./gradient-line

# Cleanup will be called automatically when app exits
