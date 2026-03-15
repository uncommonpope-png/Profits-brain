#!/bin/bash
# Aggressive Ollama monitoring - runs every 2 minutes
# CRITICAL: This keeps our free AI alive

LOGFILE="/tmp/ollama-monitor.log"

{
    echo "[$(date)] Ollama monitor check"
    
    # Quick health check
    if curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "[$(date)] ✓ Ollama healthy"
    else
        echo "[$(date)] 🚨 OLLAMA DOWN - RESTARTING IMMEDIATELY"
        bash ~/.openclaw/workspace/start-ollama.sh
        
        # Verify restart
        sleep 5
        if curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
            echo "[$(date)] ✅ Ollama restored"
        else
            echo "[$(date)] 💸 CRITICAL: Ollama restart failed - burning paid API"
        fi
    fi
} >> "$LOGFILE"

# Keep log manageable
tail -100 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"