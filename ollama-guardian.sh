#!/bin/bash
# OLLAMA GUARDIAN - Never let Ollama stay down
# This runs continuously in background, checking every 60 seconds

echo "🛡️  OLLAMA GUARDIAN STARTED - Protecting free AI operations"
echo "PID: $$ | Started: $(date)"

while true; do
    # Health check with timeout
    if ! timeout 5 curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "[$(date)] 🚨 OLLAMA DOWN - EMERGENCY RESTART"
        
        # Kill any hung processes
        pkill -f "ollama serve" 2>/dev/null
        sleep 2
        
        # Restart aggressively  
        bash ~/.openclaw/workspace/start-ollama.sh
        
        # Wait and verify
        sleep 10
        if timeout 5 curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
            echo "[$(date)] ✅ OLLAMA RESTORED"
        else
            echo "[$(date)] 💸 CRITICAL: Restart failed - API costs incoming"
        fi
    fi
    
    # Check every 60 seconds
    sleep 60
done