#!/bin/bash
# COMMAND INTERFACE - Simple HTTP server for dashboard bot commands
# Allows dashboard to send commands to bots without requiring Profit API

PORT=8081
COMMAND_QUEUE="$HOME/.openclaw/workspace/command-queue.txt"

echo "🌐 COMMAND INTERFACE ACTIVATED - Dashboard Bot Control"
echo "Started: $(date) | Port: $PORT | PID: $$"

# Create command queue if it doesn't exist
touch "$COMMAND_QUEUE"

# Simple HTTP server that accepts bot commands
while true; do
    # Listen for HTTP requests on port 8081
    echo "📡 Listening for dashboard commands on port $PORT..."
    
    # Use netcat to create simple HTTP server
    {
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: text/plain"
        echo "Access-Control-Allow-Origin: *"
        echo "Access-Control-Allow-Methods: POST, GET, OPTIONS"
        echo "Access-Control-Allow-Headers: Content-Type"
        echo ""
        echo "Command Interface Ready"
    } | nc -l -p $PORT -q 1 >/dev/null 2>&1
    
    # Check for new commands in queue and process them
    if [ -s "$COMMAND_QUEUE" ]; then
        echo "📨 Processing dashboard commands..."
        cat "$COMMAND_QUEUE"
        
        # Bot Commander will process these commands
        echo "[$(date)] Dashboard commands queued for processing" >> ~/.openclaw/workspace/command-interface.log
    fi
    
    sleep 2
done