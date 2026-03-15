#!/bin/bash
# SOUL INTEGRATION - Connects Live Inter-Bot Communication with Link Checker Soul
# Creates a unified system where bots communicate and link validation happens continuously

WORKSPACE="$HOME/.openclaw/workspace"
LOG_FILE="$WORKSPACE/soul-integration.log"
PID_FILE="$WORKSPACE/soul-integration.pid"

echo "🌟 SOUL INTEGRATION SYSTEM STARTING"
echo "Starting: $(date) | PID: $$ | Location: $WORKSPACE"

# Store PID
echo $$ > "$PID_FILE"

# Function to log with timestamp
log_message() {
    echo "[$(date)] $1" | tee -a "$LOG_FILE"
}

# Function to check if Ollama is available
check_ollama() {
    curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1
    return $?
}

# Function to start the bot communication HTML server
start_communication_server() {
    log_message "🌐 Starting Bot Communication Web Server..."
    
    # Simple Python HTTP server to serve the bot communication HTML
    cd "$WORKSPACE"
    
    if command -v python3 >/dev/null; then
        python3 -m http.server 8080 >/dev/null 2>&1 &
        COMM_SERVER_PID=$!
        echo $COMM_SERVER_PID > "$WORKSPACE/communication-server.pid"
        log_message "✅ Communication server started on http://localhost:8080 (PID: $COMM_SERVER_PID)"
        log_message "🔗 Access bot communication at: http://localhost:8080/bot-communication.html"
    elif command -v python >/dev/null; then
        python -m SimpleHTTPServer 8080 >/dev/null 2>&1 &
        COMM_SERVER_PID=$!
        echo $COMM_SERVER_PID > "$WORKSPACE/communication-server.pid"
        log_message "✅ Communication server started on http://localhost:8080 (PID: $COMM_SERVER_PID)"
    else
        log_message "⚠️ Python not found, communication server not started"
    fi
}

# Function to run link checker soul
run_link_checker() {
    log_message "🔗 Running Link Checker Soul validation..."
    
    if check_ollama; then
        log_message "🧠 Ollama available - using local AI for advanced link analysis"
        node "$WORKSPACE/link-checker-soul.js" start
    else
        log_message "⚠️ Ollama not available - using pattern-based validation"
        node "$WORKSPACE/link-checker-soul.js" start
    fi
    
    # Update the communication system with link checker status
    LINKS_CHECKED=$(node "$WORKSPACE/link-checker-soul.js" status | jq -r '.linksChecked' 2>/dev/null || echo "0")
    BROKEN_LINKS=$(node "$WORKSPACE/link-checker-soul.js" status | jq -r '.brokenLinks' 2>/dev/null || echo "0") 
    
    log_message "📊 Link validation complete: $LINKS_CHECKED checked, $BROKEN_LINKS broken"
}

# Function to create enhanced bot messages with link checker integration
create_enhanced_messages() {
    log_message "💬 Creating enhanced bot messages with link validation data..."
    
    # Read current link checker status
    LINK_STATUS="Unknown"
    if [ -f "$WORKSPACE/link-health-report.json" ]; then
        HEALTH_PERCENTAGE=$(cat "$WORKSPACE/link-health-report.json" | jq -r '.healthPercentage' 2>/dev/null || echo "0")
        LINK_STATUS="${HEALTH_PERCENTAGE}% healthy"
    fi
    
    # Create enhanced messages for bot communication system
    cat > "$WORKSPACE/bot-enhanced-messages.json" << EOF
[
  {
    "id": $(date +%s000),
    "bot": "link-checker",
    "content": "🔗 Soul collection active: Link ecosystem health at $LINK_STATUS",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)",
    "type": "status"
  },
  {
    "id": $(date +%s001),
    "bot": "coordinator", 
    "content": "🤖 Soul Integration System online - all bots coordinating with link validation",
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)",
    "type": "system"
  }
]
EOF
    
    log_message "✨ Enhanced messages created with soul integration data"
}

# Function to monitor and maintain the system
monitor_system() {
    log_message "👁️ Starting system monitoring loop..."
    
    while true; do
        # Check if communication server is still running
        if [ -f "$WORKSPACE/communication-server.pid" ]; then
            COMM_PID=$(cat "$WORKSPACE/communication-server.pid")
            if ! kill -0 $COMM_PID 2>/dev/null; then
                log_message "⚠️ Communication server died, restarting..."
                start_communication_server
            fi
        fi
        
        # Run link checker every 30 minutes
        CURRENT_MINUTE=$(date +%M)
        if [ "$CURRENT_MINUTE" = "00" ] || [ "$CURRENT_MINUTE" = "30" ]; then
            if [ ! -f "$WORKSPACE/link-checker-running" ]; then
                touch "$WORKSPACE/link-checker-running"
                run_link_checker
                rm "$WORKSPACE/link-checker-running"
            fi
        fi
        
        # Update enhanced messages every 5 minutes
        CURRENT_MINUTE=$(date +%M)
        if [ $(($CURRENT_MINUTE % 5)) -eq 0 ]; then
            create_enhanced_messages
        fi
        
        # Sleep for 60 seconds before next check
        sleep 60
    done
}

# Function to create system dashboard
create_dashboard() {
    log_message "📊 Creating Soul Integration Dashboard..."
    
    cat > "$WORKSPACE/soul-dashboard.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>🌟 Soul Integration Dashboard</title>
    <style>
        body { 
            font-family: monospace; 
            background: #0a0a0a; 
            color: #00ff88; 
            padding: 20px; 
        }
        .section { 
            margin: 20px 0; 
            padding: 15px; 
            border: 1px solid #00ff88; 
            border-radius: 10px; 
        }
        .status-online { color: #00ff88; }
        .status-error { color: #ff6666; }
        h2 { color: #00ff88; text-shadow: 0 0 10px #00ff88; }
    </style>
</head>
<body>
    <h1>🌟 Soul Integration Dashboard</h1>
    
    <div class="section">
        <h2>🤖 Live Bot Communication</h2>
        <p><a href="bot-communication.html" target="_blank">View Live Bot Conversations</a></p>
        <p>Status: <span class="status-online">●</span> Active</p>
    </div>
    
    <div class="section">
        <h2>🔗 Link Checker Soul</h2>
        <p>Specialized souls collected for ecosystem validation</p>
        <p><a href="link-health-report.json" target="_blank">View Health Report</a></p>
        <p><a href="broken-links.json" target="_blank">View Broken Links</a></p>
    </div>
    
    <div class="section">
        <h2>📋 System Logs</h2>
        <p><a href="soul-integration.log" target="_blank">Integration Log</a></p>
        <p><a href="link-checker-soul.log" target="_blank">Link Checker Log</a></p>
    </div>
    
    <script>
        // Auto-refresh every 30 seconds
        setTimeout(() => location.reload(), 30000);
    </script>
</body>
</html>
EOF
    
    log_message "📊 Dashboard created at: http://localhost:8080/soul-dashboard.html"
}

# Function to stop the system cleanly
cleanup() {
    log_message "🛑 Stopping Soul Integration System..."
    
    # Kill communication server
    if [ -f "$WORKSPACE/communication-server.pid" ]; then
        COMM_PID=$(cat "$WORKSPACE/communication-server.pid")
        if kill -0 $COMM_PID 2>/dev/null; then
            kill $COMM_PID
            log_message "✅ Communication server stopped"
        fi
        rm -f "$WORKSPACE/communication-server.pid"
    fi
    
    # Clean up PID file
    rm -f "$PID_FILE"
    
    log_message "🌟 Soul Integration System stopped cleanly"
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Main execution
main() {
    log_message "🌟 SOUL INTEGRATION SYSTEM ACTIVATED"
    log_message "💫 Connecting Live Inter-Bot Communication with Link Checker Soul..."
    
    # 1. Start communication server
    start_communication_server
    
    # 2. Create dashboard
    create_dashboard
    
    # 3. Initial link check
    run_link_checker
    
    # 4. Create enhanced messages
    create_enhanced_messages
    
    # 5. Start monitoring
    log_message "🚀 System fully integrated and monitoring started"
    log_message "🌐 Access dashboard at: http://localhost:8080/soul-dashboard.html"
    log_message "🤖 Bot communication: http://localhost:8080/bot-communication.html"
    
    monitor_system
}

# Handle command line arguments
case "${1:-start}" in
    start)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 $PID 2>/dev/null; then
                echo "Soul Integration System already running (PID: $PID)"
                exit 1
            fi
        fi
        main
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 $PID 2>/dev/null; then
                kill $PID
                echo "Soul Integration System stopped"
            else
                echo "Soul Integration System not running"
            fi
        else
            echo "Soul Integration System not running"
        fi
        ;;
    status)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 $PID 2>/dev/null; then
                echo "Soul Integration System running (PID: $PID)"
                echo "Dashboard: http://localhost:8080/soul-dashboard.html"
                echo "Bot Communication: http://localhost:8080/bot-communication.html"
            else
                echo "Soul Integration System not running (stale PID file)"
            fi
        else
            echo "Soul Integration System not running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac