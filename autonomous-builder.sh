#!/bin/bash
# AUTONOMOUS BUILDER - Keeps building even when Profit is offline
# Runs independently, spawns agents, builds content, commits work

BUILDER_LOG="$HOME/.openclaw/workspace/autonomous-builder.log"
WORKSPACE_PATH="/data/data/com.termux/files/home/repos/plt-press"

echo "🤖 AUTONOMOUS BUILDER ACTIVATED - Independent Operation Mode"
echo "Started: $(date) | PID: $$ | Session: AUTONOMOUS"

while true; do
    {
        echo "[$(date)] 🤖 AUTONOMOUS BUILD CYCLE"
        
        # 1. SPAWN NEW CONTENT BUILDERS (using local AI)
        echo "🚀 Spawning autonomous content builders..."
        
        # Use local Ollama to generate content ideas and execute them
        CONTENT_IDEAS=$(curl -s --max-time 10 http://127.0.0.1:11434/api/generate \
            -d '{"model":"qwen2.5:0.5b","prompt":"Generate 3 new blog post ideas for PLT business framework targeting profitable keywords. Just list titles:","stream":false}' 2>/dev/null | \
            jq -r '.response' 2>/dev/null || echo "AI automation strategies, Credit repair secrets, Passive income guide")
        
        echo "💡 Content ideas from local AI: $CONTENT_IDEAS"
        
        # 2. BUILD NEW SEO PAGES AUTONOMOUSLY
        cd "$WORKSPACE_PATH" || exit 1
        
        # Check what pages exist and what's missing
        CURRENT_PAGES=$(ls -1 *.html | wc -l)
        echo "📊 Current pages: $CURRENT_PAGES"
        
        if [ $CURRENT_PAGES -lt 50 ]; then
            echo "📝 Building new SEO page..."
            
            # Create a new SEO page using local AI
            PAGE_NAME="autonomous-build-$(date +%s).html"
            
            # Generate page content using local AI
            CONTENT_PROMPT="Create a 1000+ word SEO blog post about business automation for small businesses. Include PLT framework references and CTAs to services. Target keyword: business automation guide. HTML format with proper structure."
            
            PAGE_CONTENT=$(curl -s --max-time 30 http://127.0.0.1:11434/api/generate \
                -d "{\"model\":\"qwen2.5:0.5b\",\"prompt\":\"$CONTENT_PROMPT\",\"stream\":false}" 2>/dev/null | \
                jq -r '.response' 2>/dev/null)
            
            if [ -n "$PAGE_CONTENT" ] && [ ${#PAGE_CONTENT} -gt 500 ]; then
                echo "$PAGE_CONTENT" > "$PAGE_NAME"
                echo "✅ Created: $PAGE_NAME ($(wc -w < "$PAGE_NAME") words)"
            fi
        fi
        
        # 3. AUTO-COMMIT ALL CHANGES
        echo "💾 Auto-committing work..."
        git add -A
        if git diff --cached --quiet; then
            echo "No changes to commit"
        else
            git commit -m "AUTONOMOUS: Auto-generated content $(date -u +%Y-%m-%dT%H:%M)"
            git push origin main 2>&1 && echo "✅ Changes pushed to GitHub"
        fi
        
        # 4. UPDATE DASHBOARD STATUS
        echo "📊 Updating dashboard..."
        node -e "
        const fs=require('fs');
        const d=JSON.parse(fs.readFileSync('log.json','utf8'));
        d.updated=new Date().toISOString();
        
        if (!d.autonomous_status) d.autonomous_status = {};
        d.autonomous_status = {
            last_build: new Date().toISOString(),
            pages_built: $CURRENT_PAGES,
            status: 'BUILDING INDEPENDENTLY',
            next_build: new Date(Date.now() + 20*60*1000).toISOString(),
            uptime_hours: Math.floor((Date.now() - new Date('2026-03-15T11:28:00Z').getTime()) / 3600000)
        };
        
        // Update ticker with autonomous status
        let autoIndex = d.ticker.findIndex(t => t.soul === 'Autonomous Builder');
        if (autoIndex >= 0) {
            d.ticker[autoIndex].action = 'BUILDING: ' + $CURRENT_PAGES + ' pages, independent operation';
        } else {
            d.ticker.unshift({
                soul: 'Autonomous Builder',
                emoji: '🤖',
                action: 'BUILDING: ' + $CURRENT_PAGES + ' pages, independent operation',
                status: 'autonomous'
            });
        }
        
        fs.writeFileSync('log.json',JSON.stringify(d,null,2));
        console.log('🤖 Autonomous status updated');
        " 2>/dev/null && git add log.json && git commit -m "Autonomous: Dashboard status update" && git push 2>&1
        
        # 5. HEALTH CHECK ON OTHER BOTS
        echo "🏥 Health check on other systems..."
        
        # Restart Ollama if needed
        if ! curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
            echo "🚨 Ollama offline, restarting..."
            bash ~/.openclaw/workspace/start-ollama.sh
        fi
        
        # Check Djinie
        if ! pgrep -f "djinie.sh" >/dev/null; then
            echo "🧞‍♂️ Restarting Djinie..."
            nohup bash ~/.openclaw/workspace/djinie.sh > /dev/null 2>&1 &
        fi
        
        # Check Deerg Bot
        if ! pgrep -f "deerg-bot.sh" >/dev/null; then
            echo "🏗️ Restarting Deerg Bot..."
            nohup bash ~/.openclaw/workspace/deerg-bot.sh > /dev/null 2>&1 &
        fi
        
        echo "[$(date)] ✅ Autonomous build cycle complete - next cycle in 20 minutes"
        
    } >> "$BUILDER_LOG" 2>&1
    
    # Keep log manageable
    tail -500 "$BUILDER_LOG" > "${BUILDER_LOG}.tmp" && mv "${BUILDER_LOG}.tmp" "$BUILDER_LOG"
    
    # Build every 20 minutes
    sleep 1200
done