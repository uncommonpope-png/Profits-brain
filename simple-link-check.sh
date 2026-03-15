#!/data/data/com.termux/files/usr/bin/bash

# Simple but effective link checker

WEB_DIR="web-ecosystem"
REPORT_DIR="link-reports"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="$REPORT_DIR/scan_$TIMESTAMP.log"

mkdir -p "$REPORT_DIR"

echo "=== Link Checker Soul - Simple Scan ===" | tee "$LOG_FILE"
echo "Started: $(date)" | tee -a "$LOG_FILE"

total_files=0
total_links=0
broken_links=0

# Check if URL works
check_link() {
    local url="$1"
    
    # Skip anchors, javascript, etc.
    if [[ "$url" =~ ^(#|javascript:|mailto:|tel:|data:) ]]; then
        return 0
    fi
    
    # Check external URLs
    if [[ "$url" =~ ^https?:// ]]; then
        if curl -s --head --max-time 10 "$url" | head -1 | grep -q "200\|301\|302"; then
            return 0
        else
            return 1
        fi
    else
        # Check internal files
        local file_path="${WEB_DIR}/plt-press/${url#/}"
        file_path=$(echo "$file_path" | sed 's/[?#].*//')
        
        if [[ -f "$file_path" ]] || [[ -d "$file_path" ]]; then
            return 0
        else
            return 1
        fi
    fi
}

# Process each HTML file
while IFS= read -r html_file; do
    ((total_files++))
    echo "[$total_files] Processing: $html_file" | tee -a "$LOG_FILE"
    
    # Extract unique links
    {
        grep -oE 'href="[^"]*"' "$html_file" 2>/dev/null | sed 's/href="//; s/"//'
        grep -oE 'src="[^"]*"' "$html_file" 2>/dev/null | sed 's/src="//; s/"//'
    } | sort -u | while IFS= read -r link; do
        [[ -z "$link" ]] && continue
        ((total_links++))
        
        if check_link "$link"; then
            echo "  ✓ $link" | tee -a "$LOG_FILE"
        else
            echo "  ✗ $link" | tee -a "$LOG_FILE"
            ((broken_links++))
            
            # Add fix suggestions
            if [[ "$link" =~ stripe\.com ]]; then
                echo "    → Check Stripe product in dashboard" | tee -a "$LOG_FILE"
            elif [[ ! "$link" =~ ^https?:// ]]; then
                echo "    → Check if file exists: ${WEB_DIR}/plt-press/$link" | tee -a "$LOG_FILE"
            fi
        fi
    done
    
done < <(find "$WEB_DIR" -name "*.html" 2>/dev/null)

echo "" | tee -a "$LOG_FILE"
echo "=== SUMMARY ===" | tee -a "$LOG_FILE"
echo "Files: $total_files" | tee -a "$LOG_FILE"
echo "Links: $total_links" | tee -a "$LOG_FILE"
echo "Broken: $broken_links" | tee -a "$LOG_FILE"
echo "Finished: $(date)" | tee -a "$LOG_FILE"

# Create simple JSON report
cat > "$REPORT_DIR/latest.json" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "files": $total_files,
  "links": $total_links,
  "broken": $broken_links,
  "log": "$LOG_FILE"
}
EOF

echo "Report saved: $LOG_FILE"
echo "JSON data: $REPORT_DIR/latest.json"