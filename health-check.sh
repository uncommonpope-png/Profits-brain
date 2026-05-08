#!/bin/bash
# HEALTH CHECK - Ensure all autonomous systems stay online

LOG_FILE="/app/health-check.log"

{
    echo "[$(date)] 🏥 HEALTH CHECK"
    
    # Check Ollama
    if curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "✅ Ollama: ONLINE"
    else
        echo "🚨 Ollama: OFFLINE - Restarting..."
        bash /app/start-ollama.sh
    fi
    
    # Check autonomous builder
    if pgrep -f "autonomous-builder.sh" >/dev/null; then
        echo "✅ Autonomous Builder: RUNNING"
    else
        echo "🚨 Autonomous Builder: STOPPED - Restarting..."
        nohup bash /app/autonomous-builder.sh > /dev/null 2>&1 &
    fi
    
    # Check Djinie
    if pgrep -f "djinie.sh" >/dev/null; then
        echo "✅ Djinie: RUNNING"
    else
        echo "🚨 Djinie: STOPPED - Restarting..."
        nohup bash /app/djinie.sh > /dev/null 2>&1 &
    fi
    
    # Check Deerg Bot
    if pgrep -f "deerg-bot.sh" >/dev/null; then
        echo "✅ Deerg Bot: RUNNING"
    else
        echo "🚨 Deerg Bot: STOPPED - Restarting..."
        nohup bash /app/deerg-bot.sh > /dev/null 2>&1 &
    fi
    
    # PERFORMANCE MECHANICS: Count reports and update log.json
    REPORT_COUNT=$(find /app/reports/ -name "*.md" | wc -l)

    # Update log.json using node
    node -e "
    const fs = require('fs');
    const logPath = '/app/log.json';
    if (fs.existsSync(logPath)) {
        const log = JSON.parse(fs.readFileSync(logPath, 'utf8'));
        log.decisions_calculated = (log.decisions_calculated || 0) + $REPORT_COUNT;
        log.updated = new Date().toISOString();
        fs.writeFileSync(logPath, JSON.stringify(log, null, 2));
        console.log('📈 Log mechanics updated: ' + $REPORT_COUNT + ' reports factored.');
    }
    " 2>/dev/null

    echo "[$(date)] ✅ Health check complete"
    echo "---"
    
} >> "$LOG_FILE" 2>&1

# Keep log under control
tail -200 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
