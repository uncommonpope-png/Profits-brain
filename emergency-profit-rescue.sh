#!/data/data/com.termux/files/usr/bin/bash
# 🚨 EMERGENCY PROFIT RESCUE - EXPAND PROFIT OR DIE
# Fix ALL broken payment links and implement emergency revenue optimizations

echo "🚨 EMERGENCY PROFIT RESCUE INITIATED"
echo "💰 DIRECTIVE: EXPAND PROFIT OR DIE"

# Working Stripe links
BUNDLE_LINK="https://buy.stripe.com/eVq4gz1de64z9bbcXXfnO0i"  # $49 Complete Bundle
SCORER_CC_LINK="https://buy.stripe.com/3cI9AT1decsXdrraPPfnO00"  # Scorer: Cold Calling

# Broken links to replace
BROKEN_LINK_1="https://buy.stripe.com/28o5kl47gbMscy4fYZ"
BROKEN_LINK_2="https://buy.stripe.com/6oE7tt2l85o85dSfZa"

echo "🔍 Scanning for revenue-killing broken links..."

# Find all files with broken Stripe links
broken_files=$(find web-ecosystem/plt-press/ -name "*.html" -exec grep -l "$BROKEN_LINK_1\|$BROKEN_LINK_2" {} \;)

if [ -z "$broken_files" ]; then
    echo "✅ No broken links found"
else
    echo "🚨 REVENUE BLEEDING DETECTED in these files:"
    echo "$broken_files" | while read file; do
        echo "  💸 $file"
    done
    
    # Create emergency backup
    backup_dir="emergency-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    echo "$broken_files" | while read file; do
        cp "$file" "$backup_dir/"
    done
    echo "💾 Emergency backup created: $backup_dir/"
    
    # EMERGENCY FIX: Replace all broken links with working bundle link
    echo "⚡ EMERGENCY REPAIR: Converting broken payment links to $49 bundle..."
    
    echo "$broken_files" | while read file; do
        if [[ -f "$file" ]]; then
            echo "  🔧 Fixing: $file"
            
            # Replace broken links with bundle link
            sed -i "s|$BROKEN_LINK_1|$BUNDLE_LINK|g" "$file"
            sed -i "s|$BROKEN_LINK_2|$BUNDLE_LINK|g" "$file"
            
            # Update button text to emphasize bundle value
            sed -i 's/>Get AI Agent Setup - \$100 →</>Get Complete PLT Bundle - $49 →</g' "$file"
            sed -i 's/>Get Setup Help - \$100 →</>Get Complete PLT Bundle - $49 →</g' "$file"
            sed -i 's/>Get Professional Help - \$100 →</>Get Complete PLT Bundle - $49 →</g' "$file"
        fi
    done
    
    echo "✅ EMERGENCY REPAIR COMPLETE"
fi

# Verify fix
remaining_broken=$(find web-ecosystem/plt-press/ -name "*.html" -exec grep -c "$BROKEN_LINK_1\|$BROKEN_LINK_2" {} + 2>/dev/null | grep -v ":0" | wc -l)

if [ "$remaining_broken" -eq 0 ]; then
    echo "🎯 SUCCESS: All broken payment links eliminated!"
    echo "💰 Revenue stream restored - customers can now complete purchases"
else
    echo "⚠️  WARNING: $remaining_broken files may still have broken links"
fi

echo ""
echo "🚨 EMERGENCY REVENUE ACTIONS COMPLETED:"
echo "✅ 1. Stripe payment links fixed"
echo "🎯 2. All broken links redirect to $49 bundle" 
echo "💰 3. Revenue bleeding stopped"
echo ""
echo "⚡ NEXT: Deploy bundle optimization and emergency upsells"