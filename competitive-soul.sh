#!/usr/bin/env bash
# COMPETITIVE SOUL - Data-driven Battle Plan generator
# MISSION: Outrank and out-value every business framework using grounded data.

REPORTS_DIR="/app/reports"
mkdir -p "$REPORTS_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PLAN_FILE="$REPORTS_DIR/battle-plan-$TIMESTAMP.md"
DATA_FILE="/app/competitors.json"

if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Error: competitors.json not found."
    exit 1
fi

# Select a random competitor from the JSON keys
COMPETITOR=$(node -e "const d=require('$DATA_FILE'); const k=Object.keys(d); console.log(k[Math.floor(Math.random()*k.length)])")

echo "⚔️ COMPETITIVE SOUL: Analyzing $COMPETITOR framework using grounded data..."

# Extract grounded data using node
WEAKNESS=$(node -e "console.log(require('$DATA_FILE')['$COMPETITOR'].weakness)")
ADVANTAGE=$(node -e "console.log(require('$DATA_FILE')['$COMPETITOR'].plt_advantage)")
PROFIT_POT=$(node -e "console.log(require('$DATA_FILE')['$COMPETITOR'].profit_potential)")

cat > "$PLAN_FILE" << EOF
# ⚔️ PLT BATTLE PLAN: vs $COMPETITOR
**Generated:** $(date)
**Target:** $COMPETITOR Framework

## COMPETITIVE ANALYSIS (GROUNDED)
- **Primary Weakness:** $WEAKNESS
- **PLT Strategic Advantage:** $ADVANTAGE
- **Estimated Profit Potential:** $PROFIT_POT

## ACTIONABLE STEPS
1. Draft comparison content highlighting: "$ADVANTAGE over $COMPETITOR cycles."
2. Target keywords related to "$COMPETITOR implementation failures."
3. Deploy PLT Calculator as the "antidote" to $COMPETITOR complexity.

**STATUS:** STRATEGIC DOMINATION ACTIVE
EOF

echo "✅ Grounded Battle Plan generated: $PLAN_FILE"
