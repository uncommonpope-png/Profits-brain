#!/bin/bash
# Start Ollama server if not running
if ! curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
    echo "Starting Ollama server..."
    nohup ollama serve > /dev/null 2>&1 &
    sleep 3
    if curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "✓ Ollama server started"
    else
        echo "✗ Failed to start Ollama"
        exit 1
    fi
else
    echo "✓ Ollama already running"
fi