#!/bin/bash
# HEALTH CHECK - Ensure all autonomous systems stay online

LOG_FILE="$HOME/.openclaw/workspace/health-check.log"

{
    echo "[$(date)] 🏥 HEALTH CHECK"
    
    # Check Ollama
    if curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "✅ Ollama: ONLINE"
    else
        echo "🚨 Ollama: OFFLINE - Restarting..."
        bash ~/.openclaw/workspace/start-ollama.sh
    fi
    
    # Check autonomous builder
    if pgrep -f "autonomous-builder.sh" >/dev/null; then
        echo "✅ Autonomous Builder: RUNNING"
    else
        echo "🚨 Autonomous Builder: STOPPED - Restarting..."
        nohup bash ~/.openclaw/workspace/autonomous-builder.sh > /dev/null 2>&1 &
    fi
    
    # Check Djinie
    if pgrep -f "djinie.sh" >/dev/null; then
        echo "✅ Djinie: RUNNING"
    else
        echo "🚨 Djinie: STOPPED - Restarting..."
        nohup bash ~/.openclaw/workspace/djinie.sh > /dev/null 2>&1 &
    fi
    
    # Check Deerg Bot
    if pgrep -f "deerg-bot.sh" >/dev/null; then
        echo "✅ Deerg Bot: RUNNING"
    else
        echo "🚨 Deerg Bot: STOPPED - Restarting..."
        nohup bash ~/.openclaw/workspace/deerg-bot.sh > /dev/null 2>&1 &
    fi
    
    echo "[$(date)] ✅ Health check complete"
    echo "---"
    
} >> "$LOG_FILE" 2>&1

# Keep log under control
tail -200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
