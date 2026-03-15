#!/bin/bash
# SIMPLE COMMAND - Easy way for Craig to send commands to bots
# Usage: bash simple-command.sh "COMMAND_NAME"

COMMAND="$1"
COMMAND_QUEUE="$HOME/.openclaw/workspace/command-queue.txt"

if [ -z "$COMMAND" ]; then
    echo "Usage: $0 'COMMAND_NAME'"
    echo "Available commands:"
    echo "  START_ALL_BOTS - Start all autonomous systems"
    echo "  STOP_ALL_BOTS - Stop all systems"
    echo "  BUILD_NOW - Trigger immediate content build"
    echo "  ANALYZE_NOW - Run PLT analysis now"
    echo "  STATUS_ALL - Get status of all bots"
    echo "  EXPAND_UNIVERSE - Create new universes"
    echo "  OPTIMIZE_FREEDOM - Run freedom optimization"
    exit 1
fi

echo "$COMMAND" >> "$COMMAND_QUEUE"
echo "✅ Command '$COMMAND' queued for Bot Commander"
echo "Bot Commander will execute this command within 30 seconds"