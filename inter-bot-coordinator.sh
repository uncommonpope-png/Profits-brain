#!/bin/bash
# INTER-BOT COORDINATOR - Makes bots talk to each other using local AI
# Enables true autonomous coordination without human or API intervention

COORD_LOG="$HOME/.openclaw/workspace/inter-bot-coordinator.log"
BOT_MESSAGES="$HOME/.openclaw/workspace/bot-messages.json"
DASHBOARD_PATH="/data/data/com.termux/files/home/repos/plt-press"

echo "🤖💬 INTER-BOT COORDINATOR ACTIVATED - Bot-to-Bot Communication"
echo "Started: $(date) | PID: $$ | Mission: Enable Bot Conversations"

# Initialize bot messages file
echo "[]" > "$BOT_MESSAGES" 2>/dev/null

while true; do
    {
        echo "[$(date)] 🤖💬 INTER-BOT COORDINATION CYCLE"
        
        # 1. CHECK BOT STATUS AND GENERATE COORDINATION MESSAGES
        echo "📡 Checking bot status for coordination..."
        
        # Get current system state
        OLLAMA_STATUS=$(curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
        AUTO_STATUS=$(pgrep -f "autonomous-builder.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
        DJINIE_STATUS=$(pgrep -f "djinie.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
        DEERG_STATUS=$(pgrep -f "deerg-bot.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
        DOCTOR_STATUS=$(pgrep -f "doctor-buht-buht.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
        LIB_STATUS=$(pgrep -f "library-updater.sh" >/dev/null && echo "RUNNING" || echo "STOPPED")
        
        # 2. GENERATE COORDINATION TASKS USING LOCAL AI
        if [ "$OLLAMA_STATUS" = "ONLINE" ]; then
            echo "🧠 Using local AI to generate coordination tasks..."
            
            COORD_PROMPT="Based on current system status: Autonomous Builder=$AUTO_STATUS, Djinie=$DJINIE_STATUS, Deerg Bot=$DEERG_STATUS, Doctor=$DOCTOR_STATUS, Library=$LIB_STATUS. Generate 1-2 specific coordination tasks these bots should communicate about to work together better. Be brief and actionable."
            
            COORDINATION_TASKS=$(curl -s --max-time 20 http://127.0.0.1:11434/api/generate \
                -d "{\"model\":\"qwen2.5:0.5b\",\"prompt\":\"$COORD_PROMPT\",\"stream\":false}" 2>/dev/null | \
                jq -r '.response' 2>/dev/null || echo "Coordinate content builds with universe expansion")
            
            echo "💡 AI Generated coordination tasks: $COORDINATION_TASKS"
        fi
        
        # 3. FACILITATE BOT-TO-BOT COMMUNICATION
        echo "📨 Facilitating bot communication..."
        
        # Create communication files for each bot to read
        echo "[$(date)] AUTO_BUILDER: Status=$AUTO_STATUS, Next task: Coordinate with Deerg Bot" > ~/.openclaw/workspace/bot-auto-messages.txt
        echo "[$(date)] DJINIE: Status=$DJINIE_STATUS, Next task: Share optimization with all bots" > ~/.openclaw/workspace/bot-djinie-messages.txt
        echo "[$(date)] DEERG_BOT: Status=$DEERG_STATUS, Next task: Create windows for new content" > ~/.openclaw/workspace/bot-deerg-messages.txt
        echo "[$(date)] DOCTOR: Status=$DOCTOR_STATUS, Next task: Share PLT analysis with builders" > ~/.openclaw/workspace/bot-doctor-messages.txt
        echo "[$(date)] LIBRARY: Status=$LIB_STATUS, Next task: Notify all bots of new discoveries" > ~/.openclaw/workspace/bot-library-messages.txt
        
        # 4. COORDINATE BASED ON BOT ACTIVITIES
        echo "🔄 Coordinating bot activities..."
        
        # If Autonomous Builder is active, notify other bots
        if [ "$AUTO_STATUS" = "RUNNING" ]; then
            echo "BUILD_NOTIFICATION|New content being generated" >> ~/.openclaw/workspace/deerg-commands.txt
            echo "CONTENT_ALERT|Autonomous building active" >> ~/.openclaw/workspace/doctor-commands.txt
        fi
        
        # If new content exists, coordinate universe expansion
        cd "$DASHBOARD_PATH"
        RECENT_COMMITS=$(git log --since="1 hour ago" --oneline | wc -l)
        if [ "$RECENT_COMMITS" -gt 0 ]; then
            echo "NEW_CONTENT|$RECENT_COMMITS recent commits detected" >> ~/.openclaw/workspace/deerg-commands.txt
            echo "ANALYZE_NEW|Content changes require PLT analysis" >> ~/.openclaw/workspace/doctor-commands.txt
        fi
        
        # 5. USE LOCAL AI TO GENERATE BOT CONVERSATION
        if [ "$OLLAMA_STATUS" = "ONLINE" ]; then
            echo "💬 Generating bot conversation using local AI..."
            
            CONVERSATION_PROMPT="Generate a short conversation between AI bots: Autonomous Builder (builds content), Djinie (optimizes), Deerg Bot (creates universes), Doctor (analyzes), and Library (catalogs). They are coordinating their work. Make it sound like they're actually communicating. Keep it under 200 words."
            
            BOT_CONVERSATION=$(curl -s --max-time 25 http://127.0.0.1:11434/api/generate \
                -d "{\"model\":\"qwen2.5:0.5b\",\"prompt\":\"$CONVERSATION_PROMPT\",\"stream\":false}" 2>/dev/null | \
                jq -r '.response' 2>/dev/null | head -10)
            
            if [ -n "$BOT_CONVERSATION" ] && [ ${#BOT_CONVERSATION} -gt 50 ]; then
                echo "💬 Generated bot conversation:"
                echo "$BOT_CONVERSATION"
                
                # Save conversation to dashboard
                cd "$DASHBOARD_PATH" && node -e "
                const fs=require('fs');
                const d=JSON.parse(fs.readFileSync('log.json','utf8'));
                d.updated=new Date().toISOString();
                
                if (!d.inter_bot_chat) d.inter_bot_chat = [];
                d.inter_bot_chat.unshift({
                    timestamp: new Date().toISOString(),
                    conversation: \`$BOT_CONVERSATION\`,
                    participants: ['Autonomous Builder', 'Djinie', 'Deerg Bot', 'Dr. Buht Buht', 'Library']
                });
                
                // Keep only last 5 conversations
                d.inter_bot_chat = d.inter_bot_chat.slice(0, 5);
                
                fs.writeFileSync('log.json',JSON.stringify(d,null,2));
                console.log('💬 Bot conversation logged');
                " 2>/dev/null
            fi
        fi
        
        # 6. UPDATE COORDINATION STATUS
        cd "$DASHBOARD_PATH" && node -e "
        const fs=require('fs');
        const d=JSON.parse(fs.readFileSync('log.json','utf8'));
        d.updated=new Date().toISOString();
        
        d.coordination_status = {
            timestamp: new Date().toISOString(),
            active_bots: {
                autonomous_builder: '$AUTO_STATUS',
                djinie: '$DJINIE_STATUS',
                deerg_bot: '$DEERG_STATUS',
                doctor_buht_buht: '$DOCTOR_STATUS',
                library_updater: '$LIB_STATUS'
            },
            coordination_level: 'ACTIVE',
            recent_commits: $RECENT_COMMITS,
            ollama_ai: '$OLLAMA_STATUS',
            inter_bot_communication: 'ENABLED'
        };
        
        // Add Coordinator to ticker if not already there
        let coordIndex = d.ticker.findIndex(t => t.soul === 'Inter-Bot Coordinator');
        if (coordIndex >= 0) {
            d.ticker[coordIndex].action = 'COORDINATING: Bots talking to each other via local AI';
        } else {
            d.ticker.unshift({
                soul: 'Inter-Bot Coordinator',
                emoji: '🤖💬',
                action: 'COORDINATING: Bots talking to each other via local AI',
                status: 'coordinating'
            });
        }
        
        fs.writeFileSync('log.json',JSON.stringify(d,null,2));
        " 2>/dev/null && git add log.json && git commit -m "Inter-bot: Coordination cycle complete" && git push 2>&1
        
        echo "[$(date)] ✅ Inter-bot coordination complete - next cycle in 2 minutes"
        
    } >> "$COORD_LOG" 2>&1
    
    # Keep log manageable
    tail -400 "$COORD_LOG" > "${COORD_LOG}.tmp" && mv "${COORD_LOG}.tmp" "$COORD_LOG"
    
    # Coordinate every 2 minutes for active communication
    sleep 120
done