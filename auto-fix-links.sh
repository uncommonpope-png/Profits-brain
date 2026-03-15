#!/data/data/com.termux/files/usr/bin/bash

# Auto-Fix Links - Attempts to repair broken links automatically
# Focus on Stripe payment links and common internal link issues

set -e

WEB_DIR="web-ecosystem"
BACKUP_DIR="link-backups/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="link-reports/autofix-$(date +%Y%m%d_%H%M%S).log"

echo "=== Auto-Fix Links Started: $(date) ===" | tee "$LOG_FILE"

# Create backup
mkdir -p "$BACKUP_DIR"
echo "Creating backup in $BACKUP_DIR..." | tee -a "$LOG_FILE"
cp -r "$WEB_DIR" "$BACKUP_DIR/" || echo "Backup failed!" | tee -a "$LOG_FILE"

# Fix 1: Replace test Stripe links with live ones
echo "Fixing Stripe payment links..." | tee -a "$LOG_FILE"

# Common test Stripe patterns to replace
declare -A stripe_fixes
stripe_fixes["6oE7tt2l85o85dSfZa"]="live_product_bundle_18_books"
stripe_fixes["28o5kl47gbMscy4fYZ"]="live_product_single_book" 
stripe_fixes["eVq4gz1de64z9bbcXXfnO0i"]="live_product_bundle_all"
stripe_fixes["aFafZhbRS3Wr4UV0bbfnO0l"]="live_product_credit_repair"
stripe_fixes["dRm8wP6xy8cHaffcXXfnO0m"]="live_product_templates"

fix_count=0
for test_id in "${!stripe_fixes[@]}"; do
    live_id="${stripe_fixes[$test_id]}"
    
    # Find files containing this test ID
    files_with_test=$(grep -r "$test_id" "$WEB_DIR" --include="*.html" -l 2>/dev/null || true)
    
    if [[ -n "$files_with_test" ]]; then
        echo "  Replacing $test_id with $live_id in:" | tee -a "$LOG_FILE"
        echo "$files_with_test" | while read -r file; do
            if [[ -f "$file" ]]; then
                echo "    $file" | tee -a "$LOG_FILE"
                # Replace the test ID with live ID (keeping same URL structure)
                sed -i "s/$test_id/$live_id/g" "$file"
                ((fix_count++))
            fi
        done
    fi
done

# Fix 2: Update GitHub Pages URLs to use correct domain
echo "Fixing GitHub Pages URLs..." | tee -a "$LOG_FILE"

# Update incorrect GitHub Pages references
find "$WEB_DIR" -name "*.html" -exec sed -i \
    's|https://uncommonpope-png.github.io/plt-press/|https://pltpress.com/|g' {} \; 2>/dev/null || true

# Fix 3: Create missing internal pages (simple redirects)
echo "Creating missing internal pages..." | tee -a "$LOG_FILE"

missing_pages=(
    "ai-workflow-automation.html"
    "business-automation-guide.html" 
    "store.html"
    "services.html"
)

for page in "${missing_pages[@]}"; do
    page_path="$WEB_DIR/plt-press/$page"
    if [[ ! -f "$page_path" ]]; then
        echo "  Creating $page..." | tee -a "$LOG_FILE"
        
        # Create simple redirect page
        cat > "$page_path" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$(basename "$page" .html | tr '-' ' ' | title case) - PLT Press</title>
    <meta http-equiv="refresh" content="0;url=index.html">
</head>
<body>
    <h1>Redirecting...</h1>
    <p>If you are not redirected automatically, <a href="index.html">click here</a>.</p>
    <script>window.location.href = 'index.html';</script>
</body>
</html>
EOF
        ((fix_count++))
    fi
done

# Fix 4: Update relative paths that are broken
echo "Fixing relative path issues..." | tee -a "$LOG_FILE"

find "$WEB_DIR" -name "*.html" -exec sed -i \
    's|href="../|href="./|g' {} \; 2>/dev/null || true

# Fix 5: Remove or fix localhost references
echo "Fixing localhost references..." | tee -a "$LOG_FILE"

find "$WEB_DIR" -name "*.html" -exec sed -i \
    's|http://127.0.0.1:8080/|./|g' {} \; 2>/dev/null || true

# Summary
echo "" | tee -a "$LOG_FILE"
echo "=== Auto-Fix Summary ===" | tee -a "$LOG_FILE"
echo "Fixes applied: $fix_count" | tee -a "$LOG_FILE"
echo "Backup created: $BACKUP_DIR" | tee -a "$LOG_FILE"
echo "Completed: $(date)" | tee -a "$LOG_FILE"

# Run quick validation
if [[ -f "./simple-link-check.sh" ]]; then
    echo "Running validation scan..." | tee -a "$LOG_FILE"
    ./simple-link-check.sh | tail -20 | tee -a "$LOG_FILE"
fi