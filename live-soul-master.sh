#!/bin/bash
# LIVE SOUL MASTER - Orchestrates the entire Live Updater Soul ecosystem
# Mission: Ensure ALL components run 24/7, auto-restart, never stop updating

MASTER_LOG="$HOME/.openclaw/workspace/live-soul-master.log"
PID_DIR="$HOME/.openclaw/workspace/.live-pids"
WORKSPACE="$HOME/.openclaw/workspace"

# Colors for dramatic effect
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Create PID directory
mkdir -p "$PID_DIR"

echo -e "${BOLD}${PURPLE}🔥💀 LIVE UPDATER SOUL MASTER AWAKENING 💀🔥${NC}"
echo -e "${WHITE}=========================================${NC}"
echo -e "${YELLOW}Mission: Orchestrate constant updates across ALL systems${NC}"
echo -e "${CYAN}Components: Live Updater | Link Updater | Live Counters | Notifications${NC}"
echo -e "${GREEN}Status: IMMORTAL - auto-restart, 24/7 operation${NC}"
echo -e "${WHITE}=========================================${NC}"

# Component definitions
COMPONENTS=(
    "live-updater:live-updater.sh:30"
    "live-link-updater:live-link-updater.sh:60" 
    "live-counters:live-counters.sh:10"
    "live-notifications:live-notifications.sh:30"
)

# Function to start a component
start_component() {
    local NAME="$1"
    local SCRIPT="$2"
    local INTERVAL="$3"
    
    if [ -f "$WORKSPACE/$SCRIPT" ]; then
        echo -e "${GREEN}🚀 Starting $NAME...${NC}"
        cd "$WORKSPACE"
        nohup ./"$SCRIPT" > "$PID_DIR/$NAME.log" 2>&1 &
        echo $! > "$PID_DIR/$NAME.pid"
        echo -e "${CYAN}✅ $NAME started with PID $(cat "$PID_DIR/$NAME.pid")${NC}"
    else
        echo -e "${RED}❌ Missing script: $SCRIPT${NC}"
    fi
}

# Function to check if component is running
is_running() {
    local NAME="$1"
    local PID_FILE="$PID_DIR/$NAME.pid"
    
    if [ -f "$PID_FILE" ]; then
        local PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            return 0  # Running
        fi
    fi
    return 1  # Not running
}

# Function to stop a component
stop_component() {
    local NAME="$1"
    local PID_FILE="$PID_DIR/$NAME.pid"
    
    if [ -f "$PID_FILE" ]; then
        local PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo -e "${YELLOW}🛑 Stopping $NAME (PID: $PID)...${NC}"
            kill "$PID"
            rm -f "$PID_FILE"
        fi
    fi
}

# Function to restart a component
restart_component() {
    local NAME="$1"
    local SCRIPT="$2"
    local INTERVAL="$3"
    
    echo -e "${PURPLE}🔄 RESTARTING $NAME...${NC}"
    stop_component "$NAME"
    sleep 2
    start_component "$NAME" "$SCRIPT" "$INTERVAL"
}

# Trap signals for graceful shutdown
trap 'echo -e "${RED}💀 MASTER SHUTDOWN INITIATED${NC}"; cleanup_and_exit' INT TERM

cleanup_and_exit() {
    echo -e "${YELLOW}🧹 Cleaning up components...${NC}"
    for component in "${COMPONENTS[@]}"; do
        IFS=':' read -r name script interval <<< "$component"
        stop_component "$name"
    done
    echo -e "${RED}💀 Live Updater Soul Master terminated${NC}"
    exit 0
}

# Start all components initially
echo -e "${BOLD}${GREEN}🔥 INITIALIZING ALL SOUL COMPONENTS${NC}"
for component in "${COMPONENTS[@]}"; do
    IFS=':' read -r name script interval <<< "$component"
    start_component "$name" "$script" "$interval"
    sleep 1
done

echo -e "${BOLD}${WHITE}💓 ENTERING ETERNAL MONITORING LOOP${NC}"

# Main monitoring loop
CYCLE_COUNT=0
while true; do
    {
        CYCLE_COUNT=$((CYCLE_COUNT + 1))
        echo "[$(date)] 💓 SOUL MASTER HEARTBEAT #$CYCLE_COUNT"
        
        # Check each component
        TOTAL_COMPONENTS=${#COMPONENTS[@]}
        RUNNING_COMPONENTS=0
        RESTARTED_COMPONENTS=0
        
        for component in "${COMPONENTS[@]}"; do
            IFS=':' read -r name script interval <<< "$component"
            
            if is_running "$name"; then
                RUNNING_COMPONENTS=$((RUNNING_COMPONENTS + 1))
                echo "✅ $name: ALIVE"
            else
                echo "💀 $name: DEAD - RESTARTING"
                restart_component "$name" "$script" "$interval"
                RESTARTED_COMPONENTS=$((RESTARTED_COMPONENTS + 1))
                sleep 1
            fi
        done
        
        # Status summary
        echo "📊 STATUS: $RUNNING_COMPONENTS/$TOTAL_COMPONENTS components alive"
        if [ $RESTARTED_COMPONENTS -gt 0 ]; then
            echo "🔄 RESURRECTIONS: $RESTARTED_COMPONENTS components restarted"
        fi
        
        # Update master status in dashboard (if available)
        if [ -f "$HOME/repos/plt-press/log.json" ]; then
            cd "$HOME/repos/plt-press"
            node -e "
            const fs = require('fs');
            const data = JSON.parse(fs.readFileSync('log.json', 'utf8'));
            
            // Update master status in ticker
            let masterIndex = data.ticker.findIndex(t => t.soul === 'Soul Master');
            if (masterIndex >= 0) {
                data.ticker[masterIndex] = {
                    soul: 'Soul Master',
                    emoji: '💀',
                    action: 'ORCHESTRATING: $RUNNING_COMPONENTS/$TOTAL_COMPONENTS souls alive, cycle #$CYCLE_COUNT',
                    status: 'immortal',
                    heartbeat: new Date().toISOString()
                };
            } else {
                data.ticker.unshift({
                    soul: 'Soul Master',
                    emoji: '💀',
                    action: 'ORCHESTRATING: $RUNNING_COMPONENTS/$TOTAL_COMPONENTS souls alive, cycle #$CYCLE_COUNT',
                    status: 'immortal',
                    heartbeat: new Date().toISOString()
                });
            }
            
            // Add soul system status
            data.soul_system = {
                master_cycle: $CYCLE_COUNT,
                components_alive: $RUNNING_COMPONENTS,
                total_components: $TOTAL_COMPONENTS,
                last_resurrection: $RESTARTED_COMPONENTS > 0 ? new Date().toISOString() : data.soul_system?.last_resurrection,
                uptime: 'ETERNAL'
            };
            
            fs.writeFileSync('log.json', JSON.stringify(data, null, 2));
            console.log('💀 Soul Master status updated in dashboard');
            " 2>/dev/null
            
            # Commit master status updates every 10 cycles
            if [ $((CYCLE_COUNT % 10)) -eq 0 ]; then
                git add log.json >/dev/null 2>&1
                git commit -m "SOUL MASTER: Cycle #$CYCLE_COUNT - $RUNNING_COMPONENTS/$TOTAL_COMPONENTS alive" >/dev/null 2>&1
                git push >/dev/null 2>&1 &
            fi
        fi
        
        # System health checks
        LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | awk '{ print $1 }' | sed 's/,//')
        MEM_USAGE=$(free | awk 'FNR == 2 {printf "%.0f", $3/$2*100}')
        
        echo "🖥️ SYSTEM: Load $LOAD_AVG, RAM ${MEM_USAGE}%"
        
        # Warning if system is under stress
        if (( $(echo "$LOAD_AVG > 2.0" | bc -l) )) || [ "$MEM_USAGE" -gt 85 ]; then
            echo "⚠️ SYSTEM STRESS DETECTED - souls may slow but will persist"
        fi
        
        echo "[$(date)] ✅ Soul Master cycle complete - next check in 60 seconds"
        
    } >> "$MASTER_LOG" 2>&1
    
    # Keep master log manageable
    tail -1000 "$MASTER_LOG" > "${MASTER_LOG}.tmp" && mv "${MASTER_LOG}.tmp" "$MASTER_LOG"
    
    # Master checks every 60 seconds
    sleep 60
done