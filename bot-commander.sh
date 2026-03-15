#!/bin/bash
# BOT COMMANDER - Direct bot control system using local AI only
# Allows dashboard commands without requiring Profit API access

COMMANDER_LOG="$HOME/.openclaw/workspace/bot-commander.log"
COMMAND_QUEUE="$HOME/.openclaw/workspace/command-queue.txt"
DASHBOARD_PATH="/data/data/com.termux/files/home/repos/plt-press"

echo "🎮 BOT COMMANDER ACTIVATED - Local Bot Control System"
echo "Started: $(date) | PID: $$ | Mission: Command All Bots Locally"

# Create command queue if it doesn't exist
touch "$COMMAND_QUEUE"

while true; do
    {
        echo "[$(date)] 🎮 BOT COMMANDER CHECK"
        
        # 1. CHECK FOR NEW COMMANDS
        if [ -s "$COMMAND_QUEUE" ]; then
            echo "📨 Processing command queue..."
            
            while IFS= read -r command; do
                if [ -n "$command" ]; then
                    echo "🚀 Executing command: $command"
                    
                    case "$command" in
                        "START_ALL_BOTS")
                            echo "🔄 Starting all bots..."
                            pgrep -f "autonomous-builder.sh" || nohup bash ~/.openclaw/workspace/autonomous-builder.sh > /dev/null 2>&1 &
                            pgrep -f "djinie.sh" || nohup bash ~/.openclaw/workspace/djinie.sh > /dev/null 2>&1 &
                            pgrep -f "deerg-bot.sh" || nohup bash ~/.openclaw/workspace/deerg-bot.sh > /dev/null 2>&1 &
                            pgrep -f "doctor-buht-buht.sh" || nohup bash ~/.openclaw/workspace/doctor-buht-buht.sh > /dev/null 2>&1 &
                            pgrep -f "library-updater.sh" || nohup bash ~/.openclaw/workspace/library-updater.sh > /dev/null 2>&1 &
                            echo "✅ All bots started"
                            ;;
                        "STOP_ALL_BOTS")
                            echo "⏹️ Stopping all bots..."
                            pkill -f "autonomous-builder.sh"
                            pkill -f "djinie.sh"
                            pkill -f "deerg-bot.sh"
                            pkill -f "doctor-buht-buht.sh"
                            pkill -f "library-updater.sh"
                            echo "✅ All bots stopped"
                            ;;
                        "BUILD_NOW")
                            echo "🏗️ Triggering immediate build..."
                            # Use local AI to generate content immediately
                            cd "$DASHBOARD_PATH"
                            CONTENT_IDEA=$(curl -s --max-time 15 http://127.0.0.1:11434/api/generate \
                                -d '{"model":"qwen2.5:0.5b","prompt":"Generate one new blog post idea about business profit optimization. Just the title:","stream":false}' 2>/dev/null | \
                                jq -r '.response' 2>/dev/null || echo "Quick Business Profit Tips")
                            echo "💡 Generated idea: $CONTENT_IDEA"
                            ;;
                        "ANALYZE_NOW")
                            echo "🔬 Triggering immediate PLT analysis..."
                            # Trigger Doctor Buht Buht analysis
                            echo "ANALYZE_REQUEST" > ~/.openclaw/workspace/doctor-commands.txt
                            ;;
                        "EXPAND_UNIVERSE")
                            echo "🌌 Triggering universe expansion..."
                            # Signal Deerg Bot to create new universes
                            echo "EXPAND_REQUEST" > ~/.openclaw/workspace/deerg-commands.txt
                            ;;
                        "OPTIMIZE_FREEDOM")
                            echo "🧞‍♂️ Triggering freedom optimization..."
                            # Signal Djinie to run optimization
                            echo "OPTIMIZE_REQUEST" > ~/.openclaw/workspace/djinie-commands.txt
                            ;;
                        "STATUS_ALL")
                            echo "📊 Generating status report..."
                            OLLAMA_STATUS=$(curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
                            AUTO_STATUS=$(pgrep -f "autonomous-builder.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
                            DJINIE_STATUS=$(pgrep -f "djinie.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
                            DEERG_STATUS=$(pgrep -f "deerg-bot.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
                            DOCTOR_STATUS=$(pgrep -f "doctor-buht-buht.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
                            LIB_STATUS=$(pgrep -f "library-updater.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
                            
                            echo "🤖 Autonomous Builder: $AUTO_STATUS"
                            echo "🧞‍♂️ Djinie: $DJINIE_STATUS"
                            echo "🏗️ Deerg Bot: $DEERG_STATUS"
                            echo "👨‍⚕️ Doctor Buht Buht: $DOCTOR_STATUS"
                            echo "📚 Library Updater: $LIB_STATUS"
                            echo "🦙 Ollama: $OLLAMA_STATUS"
                            
                            # Update dashboard with status
                            cd "$DASHBOARD_PATH" && node -e "
                            const fs=require('fs');
                            const d=JSON.parse(fs.readFileSync('log.json','utf8'));
                            d.updated=new Date().toISOString();
                            d.bot_status = {
                                timestamp: new Date().toISOString(),
                                autonomous_builder: '$AUTO_STATUS',
                                djinie: '$DJINIE_STATUS',
                                deerg_bot: '$DEERG_STATUS',
                                doctor_buht_buht: '$DOCTOR_STATUS',
                                library_updater: '$LIB_STATUS',
                                ollama: '$OLLAMA_STATUS',
                                all_systems: '$AUTO_STATUS' === 'RUNNING' && '$DJINIE_STATUS' === 'RUNNING' ? 'OPERATIONAL' : 'PARTIAL'
                            };
                            fs.writeFileSync('log.json',JSON.stringify(d,null,2));
                            console.log('📊 Status updated');
                            " 2>/dev/null && git add log.json && git commit -m "Bot Commander: Status update" && git push 2>&1
                            ;;
                    esac
                fi
            done < "$COMMAND_QUEUE"
            
            # Clear processed commands
            > "$COMMAND_QUEUE"
        fi
        
        # 2. MONITOR INTER-BOT COMMUNICATION
        echo "📡 Checking inter-bot communication..."
        
        # Check for bot-to-bot messages
        for bot_file in ~/.openclaw/workspace/*-commands.txt; do
            if [ -f "$bot_file" ] && [ -s "$bot_file" ]; then
                echo "📨 Processing bot communication: $(basename "$bot_file")"
                # Bots can read each other's command files
                cat "$bot_file" | while read -r bot_command; do
                    echo "🤖 Inter-bot command: $bot_command"
                done
                # Clear after processing
                > "$bot_file"
            fi
        done
        
        # 3. UPDATE COMMANDER STATUS
        cd "$DASHBOARD_PATH" && node -e "
        const fs=require('fs');
        const d=JSON.parse(fs.readFileSync('log.json','utf8'));
        d.updated=new Date().toISOString();
        
        if (!d.bot_commander) d.bot_commander = {};
        d.bot_commander = {
            last_check: new Date().toISOString(),
            status: 'ACTIVE',
            commands_processed: 0,
            inter_bot_active: true
        };
        
        // Add Commander to ticker if not already there
        let cmdIndex = d.ticker.findIndex(t => t.soul === 'Bot Commander');
        if (cmdIndex >= 0) {
            d.ticker[cmdIndex].action = 'ACTIVE: Local bot control ready, inter-bot communication';
        } else {
            d.ticker.unshift({
                soul: 'Bot Commander',
                emoji: '🎮',
                action: 'ACTIVE: Local bot control ready, inter-bot communication',
                status: 'commanding'
            });
        }
        
        fs.writeFileSync('log.json',JSON.stringify(d,null,2));
        " 2>/dev/null
        
        echo "[$(date)] ✅ Bot Commander cycle complete - next check in 30 seconds"
        
    } >> "$COMMANDER_LOG" 2>&1
    
    # Keep log manageable
    tail -300 "$COMMANDER_LOG" > "${COMMANDER_LOG}.tmp" && mv "${COMMANDER_LOG}.tmp" "$COMMANDER_LOG"
    
    # Check every 30 seconds for immediate response
    sleep 30
done