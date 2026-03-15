#!/data/data/com.termux/files/usr/bin/bash

# Link Daemon - Continuous monitoring every 15 minutes
# Runs in background to monitor PLT ecosystem links

WORKSPACE_DIR="/data/data/com.termux/files/home/.openclaw/workspace"
PID_FILE="$WORKSPACE_DIR/link-daemon.pid"
LOG_FILE="$WORKSPACE_DIR/link-reports/daemon.log"

case "$1" in
    start)
        if [[ -f "$PID_FILE" ]]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Link daemon already running (PID: $PID)"
                exit 1
            fi
        fi
        
        echo "Starting Link Checker Soul daemon..." | tee -a "$LOG_FILE"
        
        # Start daemon in background
        (
            cd "$WORKSPACE_DIR"
            echo $$ > "$PID_FILE"
            
            while true; do
                echo "=== Link Monitor Cycle: $(date) ===" >> "$LOG_FILE"
                ./link-monitor.sh >> "$LOG_FILE" 2>&1
                echo "Next check in 15 minutes..." >> "$LOG_FILE"
                sleep 900  # 15 minutes
            done
        ) &
        
        echo "Link daemon started! Check $LOG_FILE for status."
        ;;
        
    stop)
        if [[ -f "$PID_FILE" ]]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Stopping link daemon (PID: $PID)..."
                kill "$PID"
                rm -f "$PID_FILE"
                echo "Link daemon stopped." | tee -a "$LOG_FILE"
            else
                echo "Link daemon not running."
                rm -f "$PID_FILE"
            fi
        else
            echo "Link daemon not running (no PID file)."
        fi
        ;;
        
    status)
        if [[ -f "$PID_FILE" ]]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Link daemon running (PID: $PID)"
                echo "Log: $LOG_FILE"
                if [[ -f "$LOG_FILE" ]]; then
                    echo "Recent activity:"
                    tail -5 "$LOG_FILE"
                fi
            else
                echo "Link daemon not running (stale PID file)"
                rm -f "$PID_FILE"
            fi
        else
            echo "Link daemon not running."
        fi
        ;;
        
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
        
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        echo "  Link Checker Soul - Monitors PLT ecosystem every 15 minutes"
        exit 1
        ;;
esac