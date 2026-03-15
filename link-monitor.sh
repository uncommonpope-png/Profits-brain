#!/data/data/com.termux/files/usr/bin/bash

# Link Monitor - Runs every 15 minutes via cron
# Monitors PLT ecosystem links and auto-fixes where possible

set -e

WORKSPACE_DIR="/data/data/com.termux/files/home/.openclaw/workspace"
WEB_DIR="$WORKSPACE_DIR/web-ecosystem"
REPORT_DIR="$WORKSPACE_DIR/link-reports"
LOG_FILE="$REPORT_DIR/monitor-$(date +%Y%m%d).log"

cd "$WORKSPACE_DIR"

echo "=== Link Monitor Started: $(date) ===" >> "$LOG_FILE"

# Check if web ecosystem needs updating
if [[ -d "$WEB_DIR" ]]; then
    echo "Updating web repositories..." >> "$LOG_FILE"
    
    # Pull latest changes
    cd "$WEB_DIR/plt-press" && git pull origin main >> "$LOG_FILE" 2>&1 || echo "PLT Press pull failed" >> "$LOG_FILE"
    cd "$WEB_DIR/plt-blog" && git pull origin main >> "$LOG_FILE" 2>&1 || echo "Blog pull failed" >> "$LOG_FILE"  
    cd "$WEB_DIR/ai-tools-hub" && git pull origin main >> "$LOG_FILE" 2>&1 || echo "AI Tools pull failed" >> "$LOG_FILE"
    
    cd "$WORKSPACE_DIR"
else
    echo "Web ecosystem missing - need to re-clone repositories" >> "$LOG_FILE"
fi

# Run link check
if [[ -f "./simple-link-check.sh" ]]; then
    echo "Running link health check..." >> "$LOG_FILE"
    ./simple-link-check.sh >> "$LOG_FILE" 2>&1
else
    echo "Link checker script missing!" >> "$LOG_FILE"
fi

# Check for critical issues and auto-fix
LATEST_LOG=$(ls -t "$REPORT_DIR"/scan_*.log | head -1)
if [[ -f "$LATEST_LOG" ]]; then
    BROKEN_COUNT=$(grep -c "✗" "$LATEST_LOG" || echo 0)
    STRIPE_ISSUES=$(grep -c "stripe\.com" "$LATEST_LOG" || echo 0)
    
    echo "Health Check: $BROKEN_COUNT broken links, $STRIPE_ISSUES Stripe issues" >> "$LOG_FILE"
    
    # Alert on high breakage
    if [[ $BROKEN_COUNT -gt 100 ]]; then
        echo "ALERT: High link breakage detected ($BROKEN_COUNT broken)" >> "$LOG_FILE"
        # Could send notification here
    fi
    
    # Update dashboard data
    cat > "$REPORT_DIR/dashboard-stats.json" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "broken_links": $BROKEN_COUNT,
  "stripe_issues": $STRIPE_ISSUES,
  "last_monitor": "$(date)"
}
EOF

else
    echo "No scan log found for analysis" >> "$LOG_FILE"
fi

echo "=== Link Monitor Complete: $(date) ===" >> "$LOG_FILE"