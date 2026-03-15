#!/bin/bash
# LIVE SOUL STATUS - Monitor the Live Updater Soul ecosystem
# Mission: Real-time status of all soul components

WORKSPACE="$HOME/.openclaw/workspace"
PID_DIR="$WORKSPACE/.live-pids"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${BOLD}${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║               🔥 LIVE SOUL STATUS 🔥                 ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to get process status
get_status() {
    local name="$1"
    local pid_file="$PID_DIR/$name.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            local cpu_usage=$(ps -p "$pid" -o %cpu --no-headers 2>/dev/null | tr -d ' ')
            local mem_usage=$(ps -p "$pid" -o %mem --no-headers 2>/dev/null | tr -d ' ')
            local runtime=$(ps -p "$pid" -o etime --no-headers 2>/dev/null | tr -d ' ')
            echo -e "${GREEN}ALIVE${NC} (PID: $pid, CPU: ${cpu_usage}%, MEM: ${mem_usage}%, Runtime: $runtime)"
        else
            echo -e "${RED}DEAD${NC} (stale PID file)"
        fi
    else
        echo -e "${RED}DEAD${NC} (no PID file)"
    fi
}

# Check Soul Master
echo -e "${BOLD}${PURPLE}💀 Soul Master:${NC}"
MASTER_STATUS="DEAD"
if pgrep -f "live-soul-master.sh" >/dev/null; then
    MASTER_PID=$(pgrep -f "live-soul-master.sh")
    MASTER_CPU=$(ps -p "$MASTER_PID" -o %cpu --no-headers 2>/dev/null | tr -d ' ')
    MASTER_MEM=$(ps -p "$MASTER_PID" -o %mem --no-headers 2>/dev/null | tr -d ' ')
    MASTER_RUNTIME=$(ps -p "$MASTER_PID" -o etime --no-headers 2>/dev/null | tr -d ' ')
    echo -e "   ${GREEN}ALIVE${NC} (PID: $MASTER_PID, CPU: ${MASTER_CPU}%, MEM: ${MASTER_MEM}%, Runtime: $MASTER_RUNTIME)"
    MASTER_STATUS="ALIVE"
else
    echo -e "   ${RED}DEAD${NC}"
fi

echo
echo -e "${BOLD}${WHITE}⚡ Soul Components:${NC}"

# Live Updater
echo -e "${YELLOW}⚡ Live Updater (30s updates):${NC}"
echo -n "   "
get_status "live-updater"

# Link Updater  
echo -e "${BLUE}🔗 Link Updater (60s scans):${NC}"
echo -n "   "
get_status "live-link-updater"

# Live Counters
echo -e "${CYAN}📊 Live Counters (10s metrics):${NC}"
echo -n "   "
get_status "live-counters"

# Notifications
echo -e "${PURPLE}🔔 Notifications (30s alerts):${NC}"
echo -n "   "
get_status "live-notifications"

echo
echo -e "${BOLD}${WHITE}📊 System Metrics:${NC}"

# System load
LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | awk '{ print $1 }' | sed 's/,//')
MEM_USAGE=$(free | awk 'FNR == 2 {printf "%.0f", $3/$2*100}')
DISK_USAGE=$(df -h "$WORKSPACE" | awk 'NR==2 {print $5}')

echo -e "   Load Average: ${LOAD_AVG}"
echo -e "   Memory Usage: ${MEM_USAGE}%"
echo -e "   Disk Usage: ${DISK_USAGE}"

# Dashboard data (if available)
if [ -f "$HOME/repos/plt-press/log.json" ]; then
    echo
    echo -e "${BOLD}${GREEN}📈 Live Dashboard Data:${NC}"
    
    cd "$HOME/repos/plt-press"
    node -e "
    const data = JSON.parse(require('fs').readFileSync('log.json', 'utf8'));
    
    if (data.live_stats) {
        console.log('   Pages: ' + (data.live_stats.total_pages || 0));
        console.log('   Words: ' + (data.live_stats.total_words || 0).toLocaleString());
        console.log('   Views: ' + (data.live_stats.live_views || 0).toLocaleString());
        console.log('   Revenue: $' + (data.live_stats.live_revenue || 0));
        console.log('   Active Agents: ' + (data.live_stats.active_agents || 0));
    }
    
    if (data.live_counters) {
        console.log('   Counter Views: ' + (data.live_counters.page_views || 0).toLocaleString());
        console.log('   Leads: ' + (data.live_counters.leads_generated || 0));
        console.log('   Agent Actions: ' + (data.live_counters.agent_actions || 0).toLocaleString());
    }
    
    if (data.counter_rates) {
        console.log('   View Rate: ' + (data.counter_rates.views_per_minute || 0).toFixed(1) + '/min');
        console.log('   Action Rate: ' + (data.counter_rates.actions_per_minute || 0).toFixed(1) + '/min');
    }
    
    " 2>/dev/null
fi

# Recent activity
echo
echo -e "${BOLD}${WHITE}🔥 Recent Activity:${NC}"

# Check logs for recent entries
for component in live-updater live-link-updater live-counters live-notifications; do
    LOG_FILE="$WORKSPACE/$component.log"
    if [ -f "$LOG_FILE" ]; then
        LAST_ENTRY=$(tail -1 "$LOG_FILE" 2>/dev/null | grep -o '\[.*\]' | head -1)
        if [ -n "$LAST_ENTRY" ]; then
            echo -e "   ${component}: ${LAST_ENTRY}"
        fi
    fi
done

# Master log
MASTER_LOG="$WORKSPACE/live-soul-master.log"
if [ -f "$MASTER_LOG" ]; then
    LAST_MASTER=$(tail -1 "$MASTER_LOG" 2>/dev/null | grep -o '\[.*\]' | head -1)
    if [ -n "$LAST_MASTER" ]; then
        echo -e "   soul-master: ${LAST_MASTER}"
    fi
fi

echo
echo -e "${BOLD}${WHITE}📝 Log Files:${NC}"
echo "   Master: tail -f $WORKSPACE/live-soul-master.log"
echo "   Updater: tail -f $WORKSPACE/live-updater.log"
echo "   Links: tail -f $WORKSPACE/live-link-updater.log"
echo "   Counters: tail -f $WORKSPACE/live-counters.log"
echo "   Notifications: tail -f $WORKSPACE/live-notifications.log"

echo
if [ "$MASTER_STATUS" = "ALIVE" ]; then
    echo -e "${BOLD}${GREEN}🔥 SYSTEM STATUS: LIVE AND PULSING 🔥${NC}"
else
    echo -e "${BOLD}${RED}💀 SYSTEM STATUS: SOUL DORMANT 💀${NC}"
    echo -e "${YELLOW}To awaken: ./launch-live-soul.sh${NC}"
fi

echo
echo -e "${WHITE}Commands:${NC}"
echo "  • Launch: ./launch-live-soul.sh"
echo "  • Stop: pkill -f live-soul-master"
echo "  • Status: ./live-soul-status.sh (this script)"
echo