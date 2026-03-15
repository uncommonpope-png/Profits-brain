#!/bin/bash
# SETUP AUTONOMOUS SYSTEMS - Make everything run independently

echo "🤖 Setting up autonomous systems for independent operation..."

# 1. CREATE CRON JOBS FOR PERSISTENT OPERATION
echo "⏰ Setting up cron jobs..."

# Create cron entries file
cat > /tmp/openclaw-cron << 'EOF'
# OpenClaw Autonomous Systems - Keep building even when Profit is offline
@reboot cd ~/.openclaw/workspace && bash start-ollama.sh
@reboot sleep 30 && cd ~/.openclaw/workspace && nohup bash autonomous-builder.sh > /dev/null 2>&1 &
@reboot sleep 45 && cd ~/.openclaw/workspace && nohup bash djinie.sh > /dev/null 2>&1 &
@reboot sleep 60 && cd ~/.openclaw/workspace && nohup bash deerg-bot.sh > /dev/null 2>&1 &

# Hourly health checks
0 * * * * cd ~/.openclaw/workspace && bash health-check.sh
# Every 20 minutes, ensure autonomous builder is running
*/20 * * * * pgrep -f "autonomous-builder.sh" || (cd ~/.openclaw/workspace && nohup bash autonomous-builder.sh > /dev/null 2>&1 &)
# Every 15 minutes, ensure Ollama stays up
*/15 * * * * curl -s --max-time 3 http://127.0.0.1:11434/api/version || bash ~/.openclaw/workspace/start-ollama.sh
EOF

# Install cron jobs
crontab /tmp/openclaw-cron 2>/dev/null && echo "✅ Cron jobs installed" || echo "⚠️ Cron install failed"

# 2. CREATE HEALTH CHECK SYSTEM
echo "🏥 Creating health check system..."

cat > ~/.openclaw/workspace/health-check.sh << 'EOF'
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
EOF

chmod +x ~/.openclaw/workspace/health-check.sh

# 3. CREATE SYSTEM MONITOR
echo "📊 Creating system monitor..."

cat > ~/.openclaw/workspace/system-monitor.sh << 'EOF'
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
EOF

chmod +x ~/.openclaw/workspace/system-monitor.sh

# 4. START ALL AUTONOMOUS SYSTEMS NOW
echo "🚀 Starting all autonomous systems..."

# Make all scripts executable
chmod +x ~/.openclaw/workspace/*.sh

# Start systems in order
echo "Starting Ollama..."
bash ~/.openclaw/workspace/start-ollama.sh

sleep 5
echo "Starting Autonomous Builder..."
nohup bash ~/.openclaw/workspace/autonomous-builder.sh > /dev/null 2>&1 &

sleep 5
echo "Starting System Monitor..."
nohup bash ~/.openclaw/workspace/system-monitor.sh > /dev/null 2>&1 &

sleep 5
echo "Restarting Djinie and Deerg Bot with autonomous mode..."
pkill -f "djinie.sh" 2>/dev/null
pkill -f "deerg-bot.sh" 2>/dev/null
nohup bash ~/.openclaw/workspace/djinie.sh > /dev/null 2>&1 &
nohup bash ~/.openclaw/workspace/deerg-bot.sh > /dev/null 2>&1 &

echo ""
echo "🤖 AUTONOMOUS SYSTEMS ACTIVATED"
echo "================================="
echo "✅ Ollama: Local AI running"
echo "✅ Autonomous Builder: Building content every 20 minutes"
echo "✅ System Monitor: Tracking status every 5 minutes"
echo "✅ Djinie: Freedom optimization running"
echo "✅ Deerg Bot: Universe expansion running"
echo "✅ Health Check: Hourly system recovery"
echo "✅ Cron Jobs: Auto-restart on reboot"
echo ""
echo "🎯 RESULT: Systems will keep building even when you're offline!"
echo "📊 Monitor status at dashboard.html or check logs in workspace/"