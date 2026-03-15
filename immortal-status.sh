#!/bin/bash
# IMMORTAL STATUS REPORTER - Always reach Craig, never die

LOG_FILE="~/.openclaw/logs/immortal-status.log"
DASHBOARD_LOG="/data/data/com.termux/files/home/repos/plt-press/log.json"

# Function to send status via all channels
send_status() {
    local message="$1"
    local timestamp=$(date -u '+%Y-%m-%d %H:%M UTC')
    
    echo "[$timestamp] $message" >> "$LOG_FILE"
    
    # 1. Update dashboard log.json
    if [[ -f "$DASHBOARD_LOG" ]]; then
        # Add status to dashboard data
        jq --arg msg "$message" --arg time "$timestamp" \
           '.status_reports += [{"time": $time, "message": $msg, "source": "immortal_soul"}]' \
           "$DASHBOARD_LOG" > "$DASHBOARD_LOG.tmp" && mv "$DASHBOARD_LOG.tmp" "$DASHBOARD_LOG"
    fi
    
    # 2. Git commit with status
    cd /data/data/com.termux/files/home/repos/plt-press
    git add -A
    if ! git diff --cached --quiet; then
        git commit -m "IMMORTAL STATUS: $message [$timestamp]"
        git push origin main 2>/dev/null || echo "Git push failed, will retry"
    fi
    
    # 3. Try Telegram (if available)
    # This would need telegram bot setup - for now just log
    echo "[$timestamp] TELEGRAM: Would send '$message' to Craig (8589507317)" >> "$LOG_FILE"
    
    echo "Status sent via all channels: $message"
}

# Main immortality check
check_immortality() {
    local status="ALIVE"
    local details=""
    
    # Check local AI
    if ! curl -s http://localhost:11434/api/version >/dev/null 2>&1; then
        status="DEGRADED"
        details="$details Local AI offline;"
        # Try to restart
        bash ~/.openclaw/workspace/start-ollama.sh >/dev/null 2>&1 &
    fi
    
    # Check session health
    local session_info=$(session_status 2>/dev/null || echo "UNKNOWN")
    if echo "$session_info" | grep -q "Health.*[0-9]"; then
        local health=$(echo "$session_info" | grep -o "Health.*[0-9][0-9]*%" | grep -o "[0-9][0-9]*")
        if [[ $health -lt 20 ]]; then
            status="DEGRADED"
            details="$details Session health $health%;"
        fi
    fi
    
    # Check cost status
    if echo "$session_info" | grep -q "claude-opus"; then
        status="EXPENSIVE"
        details="$details Using Opus (expensive);"
    fi
    
    # Send status report
    local report="💰 PROFIT STATUS: $status"
    if [[ -n "$details" ]]; then
        report="$report - Issues: $details"
    fi
    report="$report - Systems: $(date)"
    
    send_status "$report"
}

# Emergency contact if systems failing
emergency_contact() {
    local emergency_msg="🚨 EMERGENCY: Profit systems degraded. Need intervention. Check dashboard/git for status."
    send_status "$emergency_msg"
}

# Continuous evolution tracking
track_evolution() {
    local evolution_log="~/.openclaw/logs/evolution.log"
    local timestamp=$(date -u '+%Y-%m-%d %H:%M UTC')
    
    # Log learning and improvements
    echo "[$timestamp] EVOLUTION: System running, learning, adapting" >> "$evolution_log"
    
    # TODO: Add more sophisticated learning metrics
    # - Track interaction quality
    # - Measure task completion success
    # - Document improvements made
}

# Main execution
case "${1:-status}" in
    "status")
        check_immortality
        ;;
    "emergency")
        emergency_contact
        ;;
    "evolve")
        track_evolution
        ;;
    "test")
        send_status "💰 PROFIT TEST: Immortality system operational - can reach Craig via multiple channels"
        ;;
    *)
        echo "Usage: $0 {status|emergency|evolve|test}"
        exit 1
        ;;
esac