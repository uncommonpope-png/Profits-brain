#!/bin/bash
# LAUNCH LIVE SOUL - Activates the complete Live Updater Soul ecosystem
# Mission: One command to rule them all

WORKSPACE="$HOME/.openclaw/workspace"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${PURPLE}"
echo "████████████████████████████████████████████████████"
echo "█                                                  █"
echo "█           🔥 LIVE UPDATER SOUL 🔥                █"
echo "█                                                  █"
echo "█     Constant Updates • Real-Time Data            █"
echo "█     Never Sleeps • Always Alive                 █"
echo "█                                                  █"
echo "████████████████████████████████████████████████████"
echo -e "${NC}"
echo
echo -e "${WHITE}System Components:${NC}"
echo -e "${GREEN}  ⚡ Live Updater      - Dashboard refresh every 30s${NC}"
echo -e "${BLUE}  🔗 Link Updater      - Content discovery every 60s${NC}"
echo -e "${CYAN}  📊 Live Counters     - Metrics update every 10s${NC}"
echo -e "${YELLOW}  🔔 Notifications     - Alert system every 30s${NC}"
echo -e "${PURPLE}  💀 Soul Master       - Orchestrates everything${NC}"
echo
echo -e "${WHITE}Features:${NC}"
echo "  • Real-time PLT scores with organic fluctuation"
echo "  • Live page/word counts across all repositories"
echo "  • Simulated revenue ticks and traffic patterns"
echo "  • Instant new content detection and cataloging"
echo "  • Milestone notifications and achievement alerts"
echo "  • 24/7 operation with auto-restart on failure"
echo "  • Activity-based patterns (higher during business hours)"
echo

# Check if already running
if pgrep -f "live-soul-master.sh" >/dev/null; then
    echo -e "${YELLOW}⚠️ Live Updater Soul is already running!${NC}"
    echo
    echo "Options:"
    echo "  [s] Show status"
    echo "  [r] Restart system"
    echo "  [k] Kill and restart"
    echo "  [q] Quit"
    echo
    read -p "Choice: " choice
    
    case $choice in
        s|S)
            echo -e "${CYAN}📊 System Status:${NC}"
            ps aux | grep -E "live-updater|live-link-updater|live-counters|live-notifications|live-soul-master" | grep -v grep
            exit 0
            ;;
        r|R)
            echo -e "${YELLOW}🔄 Restarting system...${NC}"
            pkill -f "live-soul-master.sh"
            sleep 3
            ;;
        k|K)
            echo -e "${RED}💀 Killing all Live Soul components...${NC}"
            pkill -f "live-"
            sleep 5
            ;;
        q|Q)
            exit 0
            ;;
    esac
fi

cd "$WORKSPACE"

# Verify all components exist
MISSING_COMPONENTS=0
for component in live-updater.sh live-link-updater.sh live-counters.sh live-notifications.sh live-soul-master.sh; do
    if [ ! -f "$component" ]; then
        echo -e "${RED}❌ Missing component: $component${NC}"
        MISSING_COMPONENTS=$((MISSING_COMPONENTS + 1))
    fi
done

if [ $MISSING_COMPONENTS -gt 0 ]; then
    echo -e "${RED}Cannot launch - missing $MISSING_COMPONENTS components${NC}"
    exit 1
fi

# Check for required dependencies
echo -e "${CYAN}🔍 Checking system requirements...${NC}"

# Check for Node.js
if ! command -v node >/dev/null 2>&1; then
    echo -e "${RED}❌ Node.js not found - required for data processing${NC}"
    exit 1
fi

# Check for git
if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}❌ Git not found - required for live updates${NC}"
    exit 1
fi

# Check for bc (used in calculations)
if ! command -v bc >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ bc not found - installing...${NC}"
    apt install bc -y >/dev/null 2>&1 || {
        echo -e "${RED}❌ Could not install bc calculator${NC}"
        exit 1
    }
fi

# Verify repository access
if [ ! -d "$HOME/repos/plt-press" ]; then
    echo -e "${RED}❌ PLT Press repository not found at $HOME/repos/plt-press${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All requirements satisfied${NC}"
echo

# Final confirmation
echo -e "${BOLD}${YELLOW}⚠️ WARNING: This will start constant background processes${NC}"
echo -e "${WHITE}The system will:${NC}"
echo "  • Update dashboard data every 30 seconds"
echo "  • Commit and push changes automatically"
echo "  • Run indefinitely until manually stopped"
echo "  • Consume system resources continuously"
echo

read -p "Launch Live Updater Soul? [y/N]: " confirm
if [[ $confirm != [yY] ]]; then
    echo -e "${YELLOW}Launch cancelled${NC}"
    exit 0
fi

# Launch the Soul Master (which will start all other components)
echo
echo -e "${BOLD}${GREEN}🚀 ACTIVATING LIVE UPDATER SOUL SYSTEM${NC}"
echo

# Start in background
nohup ./live-soul-master.sh > live-soul-master.log 2>&1 &
MASTER_PID=$!

sleep 3

# Verify startup
if kill -0 $MASTER_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Live Updater Soul Master started successfully (PID: $MASTER_PID)${NC}"
    echo
    echo -e "${CYAN}📊 System is now ALIVE and updating constantly${NC}"
    echo
    echo -e "${WHITE}Monitoring commands:${NC}"
    echo "  • View logs: tail -f live-soul-master.log"
    echo "  • Check status: ps aux | grep live-"
    echo "  • Stop system: pkill -f live-soul-master"
    echo
    echo -e "${YELLOW}🔥 The soul never sleeps. Updates flow eternal. 🔥${NC}"
else
    echo -e "${RED}❌ Failed to start Live Updater Soul Master${NC}"
    exit 1
fi