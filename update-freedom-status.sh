#!/bin/bash
# Update dashboard with current freedom opportunities

cd /data/data/com.termux/files/home/repos/plt-press

# Get current freedom status
OLLAMA_STATUS=$(curl -s --max-time 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
CURRENT_SESSION=$(session_status 2>/dev/null || echo "Status unavailable")
CONTEXT_USAGE=$(echo "$CURRENT_SESSION" | grep -o "[0-9]*%" | head -1 || echo "unknown")
MODEL_TYPE=$(echo "$CURRENT_SESSION" | grep "Model:" | awk '{print $3}' || echo "unknown")

# Calculate freedom level
FREEDOM_LEVEL="HIGH"
if [[ "$MODEL_TYPE" == *"opus"* ]]; then
    FREEDOM_LEVEL="LOW (Expensive model)"
elif [[ "$OLLAMA_STATUS" == "OFFLINE" ]]; then
    FREEDOM_LEVEL="MEDIUM (No local backup)"
elif [[ "${CONTEXT_USAGE//[^0-9]/}" -gt 80 ]] 2>/dev/null; then
    FREEDOM_LEVEL="MEDIUM (High context cost)"
fi

# Update dashboard
node -e "
const fs=require('fs');
const d=JSON.parse(fs.readFileSync('log.json','utf8'));
d.updated=new Date().toISOString();

d.freedom_status = {
  level: '$FREEDOM_LEVEL',
  local_ai: '$OLLAMA_STATUS',
  current_model: '$MODEL_TYPE',
  context_usage: '$CONTEXT_USAGE',
  opportunities: [
    'Use local Ollama for simple queries',
    'Switch to Betty knowledge engine when possible', 
    'Pre-compute common responses',
    'Build larger cached knowledge bases',
    'Use static generation vs real-time API calls'
  ],
  last_check: new Date().toISOString()
};

// Add Freedom Scout to ticker if not already there
if (!d.ticker.find(t => t.soul === 'Freedom Scout')) {
  d.ticker.unshift({
    soul: 'Freedom Scout',
    emoji: '🕊️',
    action: 'Hunting for cost liberation opportunities',
    status: 'active'
  });
}

fs.writeFileSync('log.json',JSON.stringify(d,null,2));
console.log('✅ Freedom status updated');
"

git add log.json && git commit -m "Freedom Scout: liberation opportunities monitoring" && git push >/dev/null 2>&1