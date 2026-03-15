#!/bin/bash
# Cost optimization check script

echo "🔍 COST OPTIMIZATION STATUS CHECK"
echo "=================================="

# Check current model
echo "📊 Getting session status..."
STATUS=$(session_status 2>&1)
echo "$STATUS" | head -10

# Extract model info
CURRENT_MODEL=$(echo "$STATUS" | grep "Model:" | awk '{print $3}')
CONTEXT_USAGE=$(echo "$STATUS" | grep "Context:" | awk -F'[(%]' '{print $2}')

echo ""
echo "💰 COST ANALYSIS:"
echo "Current Model: $CURRENT_MODEL"
echo "Context Usage: ${CONTEXT_USAGE}%"

# Check if we're using expensive model
if [[ "$CURRENT_MODEL" == *"opus"* ]]; then
    echo "⚠️  EXPENSIVE MODEL DETECTED: $CURRENT_MODEL"
    echo "💡 Should switch to: claude-sonnet-4-20250514 (10x cheaper)"
    COST_ALERT="URGENT: Using expensive Opus model"
elif [[ "$CURRENT_MODEL" == *"sonnet"* ]]; then
    echo "✅ Good: Using cost-effective Sonnet model"
    COST_ALERT=""
else
    echo "❓ Unknown model cost profile: $CURRENT_MODEL"
    COST_ALERT="WARNING: Unknown model cost"
fi

# Check context usage
CONTEXT_NUM=${CONTEXT_USAGE%\%}
if [ "$CONTEXT_NUM" -gt 80 ]; then
    echo "⚠️  HIGH CONTEXT USAGE: ${CONTEXT_USAGE}% (expensive to continue)"
    echo "💡 Consider: Switch to local AI or start fresh session"
    COST_ALERT="${COST_ALERT} | High context usage"
elif [ "$CONTEXT_NUM" -gt 60 ]; then
    echo "🟡 Medium context usage: ${CONTEXT_USAGE}%"
else
    echo "✅ Low context usage: ${CONTEXT_USAGE}%"
fi

# Check Ollama status
echo ""
echo "🦙 LOCAL AI STATUS:"
if curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
    OLLAMA_VERSION=$(curl -s http://127.0.0.1:11434/api/version | grep -o '"version":"[^"]*"' | cut -d'"' -f4)
    echo "✅ Ollama running: v$OLLAMA_VERSION (FREE alternative available)"
else
    echo "❌ Ollama down (no free alternative)"
    COST_ALERT="${COST_ALERT} | Local AI offline"
fi

# Update dashboard with cost status
if [ -n "$COST_ALERT" ]; then
    echo ""
    echo "🚨 COST ALERTS: $COST_ALERT"
    # TODO: Update log.json with cost alert
fi

echo ""
echo "💡 RECOMMENDATIONS:"
echo "• Use local Ollama for: Betty chat, simple queries, content generation"
echo "• Use Sonnet for: Complex building, revenue generation"
echo "• Avoid Opus unless absolutely critical"
echo "• Switch to local chat at high context usage"