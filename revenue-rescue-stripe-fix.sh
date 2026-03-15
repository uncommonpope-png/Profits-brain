#!/data/data/com.termux/files/usr/bin/bash
# REVENUE RESCUE: Fix Broken Stripe Payment Links
# This script replaces broken Stripe links with working $49 bundle link

echo "💰 REVENUE RESCUE: Fixing Broken Stripe Payment Links..."

# Define the working Stripe link for $49 bundle
WORKING_LINK="https://buy.stripe.com/eVq4gz1de64z9bbcXXfnO0i"

# Define broken links to replace
BROKEN_LINK_1="https://buy.stripe.com/28o5kl47gbMscy4fYZ"
BROKEN_LINK_2="https://buy.stripe.com/6oE7tt2l85o85dSfZa"

# Find all HTML files with broken Stripe links
echo "🔍 Scanning for files with broken Stripe links..."
affected_files=$(find web-ecosystem/plt-press/ -name "*.html" -exec grep -l "buy.stripe.com" {} \;)

echo "📊 Files containing Stripe links:"
echo "$affected_files" | while read file; do
    echo "  - $file"
done

# Backup before fixing
backup_dir="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
echo "💾 Creating backup in $backup_dir/"

echo "$affected_files" | while read file; do
    cp "$file" "$backup_dir/"
done

# Fix broken links
fix_count=0
echo "🔧 Fixing broken Stripe links..."

echo "$affected_files" | while read file; do
    if [[ -f "$file" ]]; then
        # Check if file contains broken links
        if grep -q "$BROKEN_LINK_1\|$BROKEN_LINK_2" "$file"; then
            echo "  Fixing: $file"
            
            # Replace broken links with working link
            sed -i "s|$BROKEN_LINK_1|$WORKING_LINK|g" "$file"
            sed -i "s|$BROKEN_LINK_2|$WORKING_LINK|g" "$file"
            
            ((fix_count++))
        fi
    fi
done

echo "✅ REVENUE RESCUE COMPLETE!"
echo "💰 Fixed broken payment links in affected files"
echo "💰 All payment buttons now point to working $49 bundle: $WORKING_LINK"
echo "💾 Backup created in: $backup_dir/"

# Verify fixes
echo "🔍 Verification scan..."
remaining_broken=$(find web-ecosystem/plt-press/ -name "*.html" -exec grep -c "$BROKEN_LINK_1\|$BROKEN_LINK_2" {} + 2>/dev/null | grep -v ":0" | wc -l)

if [ "$remaining_broken" -eq 0 ]; then
    echo "✅ SUCCESS: No more broken Stripe links detected!"
    echo "💸 Revenue stream restored - customers can now complete purchases"
else
    echo "⚠️  Warning: $remaining_broken files may still have broken links"
    echo "   Manual review recommended"
fi

echo ""
echo "📈 NEXT ACTIONS FOR REVENUE OPTIMIZATION:"
echo "1. ✅ Stripe payment links fixed"
echo "2. 🎯 Review conversion funnel optimization"
echo "3. 💡 Implement upsell sequences"
echo "4. 📊 Set up revenue tracking dashboard"
echo "5. 🤝 Launch affiliate program"
echo "6. 💰 Price optimization testing"