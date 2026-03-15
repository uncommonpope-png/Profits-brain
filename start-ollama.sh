#!/bin/bash
# CRITICAL: Ensure Ollama never stays down - this is our free AI lifeline

echo "🦙 OLLAMA PERSISTENCE CHECK"

# Kill any hung processes first
pkill -f "ollama serve" 2>/dev/null

# Check if server responds
if curl -s --max-time 5 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
    echo "✓ Ollama responding normally"
    exit 0
fi

echo "⚡ Starting Ollama server (CRITICAL for free operations)..."

# Start with aggressive monitoring
nohup ollama serve > ~/.ollama/logs/ollama.log 2>&1 &
OLLAMA_PID=$!

# Wait and verify multiple times
for i in {1..10}; do
    sleep 2
    if curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "✅ Ollama server started successfully (PID: $OLLAMA_PID)"
        echo "💰 Free AI operations restored"
        exit 0
    fi
    echo "⏳ Attempt $i/10..."
done

echo "🚨 CRITICAL FAILURE: Ollama won't start"
echo "💸 WARNING: No free AI available - will burn paid API credits"
cat ~/.ollama/logs/ollama.log 2>/dev/null | tail -10
exit 1