#!/bin/bash
# SYSTEM MONITOR - Track autonomous operation status

while true; do
    TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
    
    # Get process stats
    OLLAMA_STATUS=$(curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
    AUTO_BUILDER=$(pgrep -f "autonomous-builder.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
    DJINIE_STATUS=$(pgrep -f "djinie.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
    DEERG_STATUS=$(pgrep -f "deerg-bot.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
    
    # Update dashboard with autonomous status
    cd /data/data/com.termux/files/home/repos/plt-press 2>/dev/null && \
    node -e "
    const fs=require('fs');
    const d=JSON.parse(fs.readFileSync('log.json','utf8'));
    d.updated=new Date().toISOString();
    
    d.system_monitor = {
        timestamp: '$TIMESTAMP',
        ollama: '$OLLAMA_STATUS',
        autonomous_builder: '$AUTO_BUILDER',
        djinie: '$DJINIE_STATUS',
        deerg_bot: '$DEERG_STATUS',
        independence_level: '$OLLAMA_STATUS' === 'ONLINE' && '$AUTO_BUILDER' === 'RUNNING' ? 'FULLY AUTONOMOUS' : 'DEPENDENT'
    };
    
    fs.writeFileSync('log.json',JSON.stringify(d,null,2));
    " 2>/dev/null && git add log.json && git commit -m "Monitor: System status update" && git push 2>&1
    
    sleep 300  # Update every 5 minutes
done
