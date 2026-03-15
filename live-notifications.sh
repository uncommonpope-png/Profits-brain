#!/bin/bash
# LIVE NOTIFICATIONS - Instant alerts when things happen
# Mission: Real-time notifications for new content, milestones, system events

NOTIFICATIONS_LOG="$HOME/.openclaw/workspace/live-notifications.log"
PLT_PATH="/data/data/com.termux/files/home/repos/plt-press"
ALERTS_FILE="$HOME/.openclaw/workspace/live-alerts.json"
LAST_CHECK_FILE="$HOME/.openclaw/workspace/.last-notification-check"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🔔 LIVE NOTIFICATION SYSTEM ACTIVATED${NC}"
echo "Mission: Instant alerts for ecosystem events"

# Initialize alerts system
if [ ! -f "$ALERTS_FILE" ]; then
    cat > "$ALERTS_FILE" << EOF
{
  "initialized": "$(date -Iseconds)",
  "notification_queue": [],
  "alert_history": [],
  "settings": {
    "revenue_alerts": true,
    "content_alerts": true,
    "milestone_alerts": true,
    "system_alerts": true,
    "traffic_alerts": true
  }
}
EOF
fi

echo "0" > "$LAST_CHECK_FILE"

while true; do
    {
        echo "[$(date)] 🔍 SCANNING FOR NOTIFICATION EVENTS"
        
        CURRENT_TIME=$(date +%s)
        LAST_CHECK=$(cat "$LAST_CHECK_FILE" 2>/dev/null || echo 0)
        
        cd "$PLT_PATH"
        NEW_NOTIFICATIONS=false
        
        # 1. CHECK FOR NEW CONTENT (compare with last check)
        if [ -f "log.json" ]; then
            DASHBOARD_DATA=$(cat log.json)
            
            # Extract current metrics
            CURRENT_PAGES=$(echo "$DASHBOARD_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).live_stats?.total_pages || 0)")
            CURRENT_REVENUE=$(echo "$DASHBOARD_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).live_stats?.live_revenue || 0)")
            ACTIVE_AGENTS=$(echo "$DASHBOARD_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).live_stats?.active_agents || 0)")
            
            # Check counter data if available
            if [ -f "$HOME/.openclaw/workspace/live-counters.json" ]; then
                COUNTER_DATA=$(cat "$HOME/.openclaw/workspace/live-counters.json")
                PAGE_VIEWS=$(echo "$COUNTER_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).counters.page_views || 0)")
                LEADS=$(echo "$COUNTER_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).counters.leads_generated || 0)")
                
                # Traffic spike detection
                CURRENT_RATE=$(echo "$COUNTER_DATA" | node -e "console.log(JSON.parse(require('fs').readFileSync('/dev/stdin')).rates.views_per_minute || 0)")
                if (( $(echo "$CURRENT_RATE > 5.0" | bc -l) )); then
                    NOTIFICATION="🚀 TRAFFIC SPIKE: $CURRENT_RATE views/min (normal: ~0.8)"
                    echo -e "${GREEN}$NOTIFICATION${NC}"
                    NEW_NOTIFICATIONS=true
                    
                    node -e "
                    const fs = require('fs');
                    const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
                    alerts.notification_queue.push({
                        timestamp: new Date().toISOString(),
                        type: 'traffic_spike',
                        message: '$NOTIFICATION',
                        priority: 'high'
                    });
                    fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
                    "
                fi
            fi
        fi
        
        # 2. REVENUE NOTIFICATIONS
        if [ "$CURRENT_REVENUE" -gt 0 ] && [ $((CURRENT_TIME % 1800)) -lt 30 ]; then  # Every 30 minutes
            NOTIFICATION="💰 REVENUE UPDATE: \$$CURRENT_REVENUE total earned"
            echo -e "${GREEN}$NOTIFICATION${NC}"
            NEW_NOTIFICATIONS=true
            
            node -e "
            const fs = require('fs');
            const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
            alerts.notification_queue.push({
                timestamp: new Date().toISOString(),
                type: 'revenue',
                message: '$NOTIFICATION',
                priority: 'medium'
            });
            fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
            "
        fi
        
        # 3. SYSTEM STATUS NOTIFICATIONS
        DEAD_AGENTS=0
        for process in autonomous-builder library-updater deerg-bot djinie doctor-buht-buht; do
            if ! pgrep -f "$process" >/dev/null 2>&1; then
                DEAD_AGENTS=$((DEAD_AGENTS + 1))
            fi
        done
        
        if [ "$DEAD_AGENTS" -gt 0 ]; then
            NOTIFICATION="⚠️ SYSTEM ALERT: $DEAD_AGENTS agents offline ($(ps aux | grep -E 'autonomous-builder|library-updater|deerg-bot|djinie|doctor-buht-buht' | grep -v grep | wc -l) active)"
            echo -e "${YELLOW}$NOTIFICATION${NC}"
            NEW_NOTIFICATIONS=true
            
            node -e "
            const fs = require('fs');
            const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
            alerts.notification_queue.push({
                timestamp: new Date().toISOString(),
                type: 'system_alert',
                message: '$NOTIFICATION',
                priority: 'high'
            });
            fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
            "
        fi
        
        # 4. MILESTONE NOTIFICATIONS
        if [ -f "$HOME/.openclaw/workspace/live-counters.json" ]; then
            MILESTONE_CHECK=$(node -e "
            const fs = require('fs');
            const counters = JSON.parse(fs.readFileSync('$HOME/.openclaw/workspace/live-counters.json', 'utf8'));
            const views = counters.counters.page_views;
            const words = counters.counters.total_words;
            const actions = counters.counters.agent_actions;
            
            // Check for round number milestones
            if (views % 500 === 0 && views > 0) console.log('VIEWS_' + views);
            if (words % 10000 === 0 && words > 0) console.log('WORDS_' + words);
            if (actions % 1000 === 0 && actions > 0) console.log('ACTIONS_' + actions);
            ")
            
            if [ -n "$MILESTONE_CHECK" ]; then
                case "$MILESTONE_CHECK" in
                    VIEWS_*)
                        NUMBER=$(echo "$MILESTONE_CHECK" | cut -d'_' -f2)
                        NOTIFICATION="🎉 MILESTONE: $NUMBER page views achieved!"
                        ;;
                    WORDS_*)
                        NUMBER=$(echo "$MILESTONE_CHECK" | cut -d'_' -f2)
                        NOTIFICATION="📝 MILESTONE: $NUMBER words across ecosystem!"
                        ;;
                    ACTIONS_*)
                        NUMBER=$(echo "$MILESTONE_CHECK" | cut -d'_' -f2)
                        NOTIFICATION="🤖 MILESTONE: $NUMBER agent actions completed!"
                        ;;
                esac
                
                if [ -n "$NOTIFICATION" ]; then
                    echo -e "${PURPLE}$NOTIFICATION${NC}"
                    NEW_NOTIFICATIONS=true
                    
                    node -e "
                    const fs = require('fs');
                    const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
                    alerts.notification_queue.push({
                        timestamp: new Date().toISOString(),
                        type: 'milestone',
                        message: '$NOTIFICATION',
                        priority: 'medium'
                    });
                    fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
                    "
                fi
            fi
        fi
        
        # 5. CONTENT NOTIFICATIONS (check for recent git commits)
        RECENT_COMMITS=$(git log --since="5 minutes ago" --oneline 2>/dev/null | wc -l)
        if [ "$RECENT_COMMITS" -gt 0 ]; then
            LATEST_COMMIT=$(git log --oneline -1 2>/dev/null | cut -d' ' -f2-)
            NOTIFICATION="📝 NEW CONTENT: '$LATEST_COMMIT'"
            echo -e "${BLUE}$NOTIFICATION${NC}"
            NEW_NOTIFICATIONS=true
            
            node -e "
            const fs = require('fs');
            const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
            alerts.notification_queue.push({
                timestamp: new Date().toISOString(),
                type: 'content',
                message: '$NOTIFICATION',
                priority: 'low'
            });
            fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
            "
        fi
        
        # 6. UPDATE DASHBOARD WITH NOTIFICATIONS
        if [ "$NEW_NOTIFICATIONS" = true ]; then
            node -e "
            const fs = require('fs');
            const dashData = JSON.parse(fs.readFileSync('log.json', 'utf8'));
            const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
            
            // Add notification system to ticker
            let notifIndex = dashData.ticker.findIndex(t => t.soul === 'Notification System');
            const queueSize = alerts.notification_queue.length;
            
            if (notifIndex >= 0) {
                dashData.ticker[notifIndex] = {
                    soul: 'Notification System',
                    emoji: '🔔',
                    action: 'ALERTS: ' + queueSize + ' active notifications',
                    status: 'monitoring',
                    heartbeat: new Date().toISOString()
                };
            } else {
                dashData.ticker.push({
                    soul: 'Notification System',
                    emoji: '🔔',
                    action: 'ALERTS: ' + queueSize + ' active notifications',
                    status: 'monitoring',
                    heartbeat: new Date().toISOString()
                });
            }
            
            // Add recent alerts to dashboard
            dashData.recent_alerts = alerts.notification_queue.slice(-5);
            
            fs.writeFileSync('log.json', JSON.stringify(dashData, null, 2));
            console.log('🔔 Notifications updated in dashboard');
            " 2>/dev/null
            
            git add log.json "$ALERTS_FILE" >/dev/null 2>&1
            git commit -m "NOTIFICATIONS: Alert system update" >/dev/null 2>&1
            git push >/dev/null 2>&1 &
        fi
        
        # 7. CLEANUP OLD NOTIFICATIONS
        node -e "
        const fs = require('fs');
        const alerts = JSON.parse(fs.readFileSync('$ALERTS_FILE', 'utf8'));
        const oneHourAgo = new Date(Date.now() - 3600000);
        
        // Move old notifications to history
        const old = alerts.notification_queue.filter(n => new Date(n.timestamp) < oneHourAgo);
        alerts.alert_history.push(...old);
        alerts.notification_queue = alerts.notification_queue.filter(n => new Date(n.timestamp) >= oneHourAgo);
        
        // Keep history manageable (last 100)
        if (alerts.alert_history.length > 100) {
            alerts.alert_history = alerts.alert_history.slice(-100);
        }
        
        fs.writeFileSync('$ALERTS_FILE', JSON.stringify(alerts, null, 2));
        " 2>/dev/null
        
        echo "$CURRENT_TIME" > "$LAST_CHECK_FILE"
        echo "[$(date)] ✅ Notification scan complete - next scan in 30 seconds"
        
    } >> "$NOTIFICATIONS_LOG" 2>&1
    
    # Keep log manageable
    tail -300 "$NOTIFICATIONS_LOG" > "${NOTIFICATIONS_LOG}.tmp" && mv "${NOTIFICATIONS_LOG}.tmp" "$NOTIFICATIONS_LOG"
    
    # Check every 30 seconds for instant notifications
    sleep 30
done