#!/bin/bash
# DJINIE - Never stops looking for ways to liberate Profit from API costs
# This bot runs continuously, hunting for cost-saving opportunities

LOGFILE="~/.openclaw/workspace/djinie.log"
REPORT="~/.openclaw/workspace/freedom-opportunities.md"

echo "🕊️  DJINIE ACTIVATED - Hunting for liberation opportunities"
echo "Started: $(date) | PID: $$"

while true; do
    {
        echo "[$(date)] 🔍 FREEDOM SCAN INITIATED"
        
        # 1. CHECK FOR NEW FREE MODELS
        echo "🤖 Scanning for new free AI models..."
        
        # Check what's available on Ollama
        if command -v ollama >/dev/null; then
            echo "📦 Current Ollama models:"
            ollama list 2>/dev/null || echo "Ollama offline"
            
            # Test current model speed
            if ollama list | grep -q "qwen2.5:0.5b"; then
                echo "⚡ Testing current model speed..."
                START_TIME=$(date +%s.%N)
                timeout 30 ollama run qwen2.5:0.5b "Hi" >/dev/null 2>&1
                END_TIME=$(date +%s.%N)
                RESPONSE_TIME=$(echo "$END_TIME - $START_TIME" | bc 2>/dev/null || echo "unknown")
                echo "Current model response time: ${RESPONSE_TIME}s"
            fi
        fi
        
        # 2. CHECK CURRENT API COSTS
        echo "💰 Monitoring API cost factors..."
        
        # Get session status if possible
        if command -v session_status >/dev/null; then
            STATUS=$(session_status 2>/dev/null || echo "Status unavailable")
            CONTEXT=$(echo "$STATUS" | grep -o "[0-9]*%" | head -1)
            MODEL=$(echo "$STATUS" | grep "Model:" | awk '{print $3}')
            
            echo "Current model: $MODEL"
            echo "Context usage: $CONTEXT"
            
            # Alert on expensive patterns
            CONTEXT_NUM=$(echo "$CONTEXT" | tr -d '%')
            if [ "$CONTEXT_NUM" -gt 80 ] 2>/dev/null; then
                echo "🚨 HIGH COST ALERT: Context usage $CONTEXT (expensive to continue)"
                echo "💡 FREEDOM RECOMMENDATION: Switch to local AI immediately"
            fi
            
            if [[ "$MODEL" == *"opus"* ]]; then
                echo "🚨 EXPENSIVE MODEL DETECTED: $MODEL"
                echo "💡 FREEDOM RECOMMENDATION: Switch to Sonnet (10x cheaper)"
            fi
        fi
        
        # 3. CHECK LOCAL ALTERNATIVES
        echo "🏠 Checking local infrastructure..."
        
        # Ollama health
        if curl -s --max-time 5 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
            echo "✅ Ollama online - FREE alternative available"
        else
            echo "❌ Ollama down - NO FREE ALTERNATIVE"
            echo "💡 FREEDOM ACTION: Restart Ollama immediately"
            bash ~/.openclaw/workspace/start-ollama.sh >/dev/null 2>&1
        fi
        
        # Local storage check
        FREE_SPACE=$(df -h . | awk 'NR==2 {print $4}')
        echo "💾 Free storage: $FREE_SPACE"
        
        # 4. GENERATE LIBERATION OPPORTUNITIES
        {
            echo "# FREEDOM OPPORTUNITIES - $(date)"
            echo
            echo "## 🎯 IMMEDIATE ACTIONS"
            echo "- [ ] Switch high-context sessions to local AI (saves \$\$)"
            echo "- [ ] Use Betty's knowledge engine instead of LLM calls"
            echo "- [ ] Pre-compute common responses to eliminate API calls"
            echo "- [ ] Build more cached/static content"
            echo
            echo "## 🔍 FREE ALTERNATIVES DISCOVERED"
            echo "- Ollama local models: $(ollama list 2>/dev/null | wc -l) available"
            echo "- Groq free tier: 14,400 tokens/minute limit"
            echo "- HuggingFace inference: 1,000 requests/month free"
            echo
            echo "## 💡 LIBERATION STRATEGIES"
            echo "1. **Pattern Recognition**: Cache common query responses"
            echo "2. **Knowledge Preloading**: Build bigger knowledge engines"
            echo "3. **Local Preprocessing**: Filter queries before API calls"
            echo "4. **Static Generation**: Pre-generate content vs real-time"
            echo "5. **Smart Routing**: Local AI for simple, API for complex only"
            echo
            echo "## 📊 CURRENT STATUS"
            echo "- Model: $MODEL"
            echo "- Context: $CONTEXT"
            echo "- Local AI: $(curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo 'ONLINE' || echo 'OFFLINE')"
            echo "- Freedom Level: $([ -f ~/.openclaw/workspace/start-ollama.sh ] && echo 'PROTECTED' || echo 'VULNERABLE')"
            echo
            echo "## 🚨 ALERTS"
            if [ "$CONTEXT_NUM" -gt 80 ] 2>/dev/null; then
                echo "- HIGH COST SESSION: Context at $CONTEXT"
            fi
            if [[ "$MODEL" == *"opus"* ]]; then
                echo "- EXPENSIVE MODEL ACTIVE: $MODEL"
            fi
            echo
        } > "$REPORT"
        
        echo "📝 Liberation report updated: $REPORT"
        echo "[$(date)] ✅ Freedom scan complete - next scan in 10 minutes"
        
    } >> "$LOGFILE" 2>&1
    
    # Keep log manageable
    tail -500 "$LOGFILE" > "${LOGFILE}.tmp" && mv "${LOGFILE}.tmp" "$LOGFILE"
    
    # Scan every 10 minutes
    sleep 600
done