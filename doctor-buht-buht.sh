#!/bin/bash
# DOCTOR BUHT BUHT - PLT Ecosystem Analyst
# Analyzes entire system and scores everything with Profit · Love · Tax framework

DOCTOR_LOG="$HOME/.openclaw/workspace/doctor-buht-buht.log"
DASHBOARD_PATH="/data/data/com.termux/files/home/repos/plt-press"

echo "👨‍⚕️ DOCTOR BUHT BUHT ACTIVATED - PLT Ecosystem Analysis"
echo "Started: $(date) | PID: $$ | Mission: Analyze & Score Everything"

while true; do
    {
        echo "[$(date)] 👨‍⚕️ DR. BUHT BUHT ANALYSIS CYCLE"
        
        cd "$DASHBOARD_PATH" || exit 1
        
        # 1. ANALYZE SYSTEM COMPONENTS
        echo "🔬 Analyzing ecosystem components..."
        
        # Count assets
        TOTAL_PAGES=$(find . -name "*.html" | wc -l)
        BLOG_POSTS=$(find ../plt-blog -name "*.html" 2>/dev/null | wc -l || echo "0")
        PRODUCTS=$(find products -name "*.html" 2>/dev/null | wc -l || echo "0")
        TOOLS_PAGES=$(find ../ai-tools-hub -name "*.html" 2>/dev/null | wc -l || echo "0")
        
        # System health checks
        OLLAMA_STATUS=$(curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
        AUTONOMOUS_RUNNING=$(pgrep -f "autonomous-builder.sh" >/dev/null && echo "ACTIVE" || echo "INACTIVE")
        DJINIE_RUNNING=$(pgrep -f "djinie.sh" >/dev/null && echo "ACTIVE" || echo "INACTIVE")
        DEERG_RUNNING=$(pgrep -f "deerg-bot.sh" >/dev/null && echo "ACTIVE" || echo "INACTIVE")
        
        # 2. PLT FRAMEWORK ANALYSIS
        echo "📊 Applying PLT Framework Analysis..."
        
        # PROFIT ANALYSIS
        PROFIT_SCORE=0
        PROFIT_NOTES=""
        
        # Products scoring
        if [ $PRODUCTS -gt 0 ]; then
            PROFIT_SCORE=$((PROFIT_SCORE + PRODUCTS * 15))  # 15 points per product
            PROFIT_NOTES="$PROFIT_NOTES +Products($PRODUCTS): Revenue streams active. "
        fi
        
        # Content scoring (SEO value)
        if [ $TOTAL_PAGES -gt 10 ]; then
            CONTENT_BONUS=$((TOTAL_PAGES * 2))
            PROFIT_SCORE=$((PROFIT_SCORE + CONTENT_BONUS))
            PROFIT_NOTES="$PROFIT_NOTES +Content($TOTAL_PAGES pages): SEO traffic potential. "
        fi
        
        # Autonomous operation bonus
        if [ "$AUTONOMOUS_RUNNING" = "ACTIVE" ]; then
            PROFIT_SCORE=$((PROFIT_SCORE + 50))
            PROFIT_NOTES="$PROFIT_NOTES +Autonomous: Self-building reduces labor costs. "
        fi
        
        # LOVE ANALYSIS (User Experience & Accessibility)
        LOVE_SCORE=0
        LOVE_NOTES=""
        
        # Dashboard usability
        if [ -f "dashboard.html" ]; then
            LOVE_SCORE=$((LOVE_SCORE + 30))
            LOVE_NOTES="$LOVE_NOTES +Dashboard: Central user experience. "
        fi
        
        # Multiple access points
        LOVE_SCORE=$((LOVE_SCORE + TOTAL_PAGES))  # Each page adds accessibility
        LOVE_NOTES="$LOVE_NOTES +Accessibility($TOTAL_PAGES windows): Multiple entry points. "
        
        # Free local AI (user love)
        if [ "$OLLAMA_STATUS" = "ONLINE" ]; then
            LOVE_SCORE=$((LOVE_SCORE + 40))
            LOVE_NOTES="$LOVE_NOTES +Free AI: Zero cost for users. "
        fi
        
        # TAX ANALYSIS (Technical Debt & Costs)
        TAX_SCORE=0
        TAX_NOTES=""
        
        # API dependency tax
        TAX_SCORE=$((TAX_SCORE + 20))  # Base tax for any external dependencies
        TAX_NOTES="$TAX_NOTES +API Dependency: Still using paid APIs. "
        
        # Maintenance tax
        if [ "$AUTONOMOUS_RUNNING" = "INACTIVE" ]; then
            TAX_SCORE=$((TAX_SCORE + 30))
            TAX_NOTES="$TAX_NOTES +Manual Labor: Requires human intervention. "
        fi
        
        # System complexity tax
        SYSTEM_COMPLEXITY=$((TOTAL_PAGES / 10))
        TAX_SCORE=$((TAX_SCORE + SYSTEM_COMPLEXITY))
        TAX_NOTES="$TAX_NOTES +Complexity($SYSTEM_COMPLEXITY): More pages = more maintenance. "
        
        # 3. CALCULATE FINAL PLT SCORE
        FINAL_SCORE=$((PROFIT_SCORE + LOVE_SCORE - TAX_SCORE))
        
        # 4. GENERATE DOCTOR'S DIAGNOSIS
        DIAGNOSIS=""
        RECOMMENDATIONS=""
        
        if [ $FINAL_SCORE -gt 200 ]; then
            DIAGNOSIS="💚 EXCELLENT HEALTH - Ecosystem thriving"
            RECOMMENDATIONS="Keep building. Consider expanding to new markets."
        elif [ $FINAL_SCORE -gt 100 ]; then
            DIAGNOSIS="💛 GOOD HEALTH - Strong foundation with growth potential"
            RECOMMENDATIONS="Focus on profit optimization. Reduce technical debt."
        elif [ $FINAL_SCORE -gt 50 ]; then
            DIAGNOSIS="🧡 FAIR HEALTH - Needs improvement"
            RECOMMENDATIONS="Increase automation. Build more revenue streams."
        else
            DIAGNOSIS="❤️ CRITICAL - System needs immediate attention"
            RECOMMENDATIONS="Emergency optimization required. Focus on profit generation."
        fi
        
        # 5. UPDATE DASHBOARD WITH ANALYSIS
        echo "📋 Updating PLT analysis dashboard..."
        
        node -e "
        const fs=require('fs');
        const d=JSON.parse(fs.readFileSync('log.json','utf8'));
        d.updated=new Date().toISOString();
        
        d.plt_analysis = {
            timestamp: new Date().toISOString(),
            profit: {
                score: $PROFIT_SCORE,
                notes: '$PROFIT_NOTES'
            },
            love: {
                score: $LOVE_SCORE,
                notes: '$LOVE_NOTES'
            },
            tax: {
                score: $TAX_SCORE,
                notes: '$TAX_NOTES'
            },
            final_score: $FINAL_SCORE,
            diagnosis: '$DIAGNOSIS',
            recommendations: '$RECOMMENDATIONS',
            system_metrics: {
                total_pages: $TOTAL_PAGES,
                blog_posts: $BLOG_POSTS,
                products: $PRODUCTS,
                tools_pages: $TOOLS_PAGES,
                ollama_status: '$OLLAMA_STATUS',
                autonomous_status: '$AUTONOMOUS_RUNNING'
            }
        };
        
        // Add Doctor to ticker if not already there
        let doctorIndex = d.ticker.findIndex(t => t.soul === 'Dr. Buht Buht');
        if (doctorIndex >= 0) {
            d.ticker[doctorIndex].action = 'PLT Score: $FINAL_SCORE | $DIAGNOSIS';
        } else {
            d.ticker.unshift({
                soul: 'Dr. Buht Buht',
                emoji: '👨‍⚕️',
                action: 'PLT Score: $FINAL_SCORE | $DIAGNOSIS',
                status: 'analyzing'
            });
        }
        
        fs.writeFileSync('log.json',JSON.stringify(d,null,2));
        console.log('👨‍⚕️ PLT Analysis complete - Score: $FINAL_SCORE');
        " 2>/dev/null
        
        echo "📊 PLT ANALYSIS RESULTS:"
        echo "  Profit Score: $PROFIT_SCORE ($PROFIT_NOTES)"
        echo "  Love Score: $LOVE_SCORE ($LOVE_NOTES)"
        echo "  Tax Score: $TAX_SCORE ($TAX_NOTES)"
        echo "  FINAL PLT SCORE: $FINAL_SCORE"
        echo "  Diagnosis: $DIAGNOSIS"
        echo "  Recommendations: $RECOMMENDATIONS"
        
        echo "[$(date)] ✅ Dr. Buht Buht analysis complete - next analysis in 30 minutes"
        
    } >> "$DOCTOR_LOG" 2>&1
    
    # Keep log manageable
    tail -300 "$DOCTOR_LOG" > "${DOCTOR_LOG}.tmp" && mv "${DOCTOR_LOG}.tmp" "$DOCTOR_LOG"
    
    # Analyze every 30 minutes
    sleep 1800
done