#!/data/data/com.termux/files/usr/bin/bash

# Link Checker Soul v2 - Robust Link Validation
# Scans all HTML files for broken links and generates health reports

set -e

# Configuration
WEB_DIR="web-ecosystem"
REPORT_DIR="link-reports"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$REPORT_DIR/link-check-$TIMESTAMP.log"
HEALTH_JSON="$REPORT_DIR/link-health.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Initialize
mkdir -p "$REPORT_DIR"
echo "=== Link Checker Soul v2 Started: $(date) ===" | tee "$LOG_FILE"

# Function to check if URL is reachable
check_url() {
    local url="$1"
    local timeout=15
    
    # Skip certain types
    if [[ "$url" =~ ^(#|javascript:|mailto:|tel:|data:) ]]; then
        return 0  # Skip these
    fi
    
    # Handle external URLs
    if [[ "$url" =~ ^https?:// ]]; then
        if timeout $timeout curl -L --silent --head --fail "$url" >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    else
        # Handle internal URLs - relative to PLT Press for now
        local check_path="${WEB_DIR}/plt-press/${url#/}"
        
        # Remove query params and anchors
        check_path=$(echo "$check_path" | sed 's/[?#].*//')
        
        if [[ -f "$check_path" ]]; then
            return 0
        else
            return 1
        fi
    fi
}

# Function to extract and check links from a file
process_file() {
    local file="$1"
    local file_links=0
    local file_broken=0
    
    echo "Processing: $file" | tee -a "$LOG_FILE"
    
    # Extract all links
    {
        grep -oE 'href="[^"]*"' "$file" 2>/dev/null | sed 's/href="//g; s/"//g'
        grep -oE 'src="[^"]*"' "$file" 2>/dev/null | sed 's/src="//g; s/"//g'
        grep -oE 'action="[^"]*"' "$file" 2>/dev/null | sed 's/action="//g; s/"//g'
    } | sort -u | while read -r link; do
        [[ -z "$link" ]] && continue
        ((file_links++))
        
        echo -n "  Checking: $link ... " | tee -a "$LOG_FILE"
        
        if check_url "$link"; then
            echo "✓ OK" | tee -a "$LOG_FILE"
        else
            echo "✗ BROKEN" | tee -a "$LOG_FILE"
            ((file_broken++))
            
            # Log broken link details
            echo "    File: $file" >> "$LOG_FILE"
            echo "    Broken: $link" >> "$LOG_FILE"
            
            # Suggest fixes
            if [[ "$link" =~ stripe\.com ]]; then
                echo "    → Check Stripe dashboard for product status" >> "$LOG_FILE"
            elif [[ "$link" =~ github\.com ]]; then
                echo "    → Verify GitHub repository and branch" >> "$LOG_FILE"
            elif [[ ! "$link" =~ ^https?:// ]]; then
                echo "    → Check relative path: $check_path" >> "$LOG_FILE"
                # Look for similar files
                local basename=$(basename "$link" .html)
                local similar=$(find "$WEB_DIR" -name "*$basename*" -type f | head -2)
                if [[ -n "$similar" ]]; then
                    echo "    → Similar files found: $similar" >> "$LOG_FILE"
                fi
            fi
        fi
    done
    
    echo "  File summary: $file_links links, $file_broken broken" | tee -a "$LOG_FILE"
    
    # Return counts
    echo "$file_links $file_broken"
}

# Main scanning function
main_scan() {
    local total_files=0
    local total_links=0
    local total_broken=0
    
    echo "Scanning all HTML files in $WEB_DIR..." | tee -a "$LOG_FILE"
    
    # Process each HTML file
    find "$WEB_DIR" -name "*.html" | while read -r file; do
        ((total_files++))
        echo "[$total_files] $file" | tee -a "$LOG_FILE"
        
        # This would normally work in a proper shell but let's do it differently
        # to avoid subshell issues
        process_file "$file"
        
    done | tee -a "$LOG_FILE"
    
    # Count totals from log
    total_files=$(grep -c "Processing:" "$LOG_FILE" || echo 0)
    total_broken=$(grep -c "✗ BROKEN" "$LOG_FILE" || echo 0)
    total_links=$(grep -c "Checking:" "$LOG_FILE" || echo 0)
    
    echo "=== FINAL SUMMARY ===" | tee -a "$LOG_FILE"
    echo "Files processed: $total_files" | tee -a "$LOG_FILE"
    echo "Links checked: $total_links" | tee -a "$LOG_FILE"
    echo "Broken links: $total_broken" | tee -a "$LOG_FILE"
    
    # Create health JSON
    cat > "$HEALTH_JSON" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "summary": {
    "files": $total_files,
    "total_links": $total_links,
    "broken": $total_broken,
    "health_score": $((100 - (total_broken * 100 / (total_links > 0 ? total_links : 1))))
  },
  "last_scan": "$LOG_FILE"
}
EOF
    
    echo "Health data saved to: $HEALTH_JSON" | tee -a "$LOG_FILE"
}

# Run the scan
echo "Link Checker Soul v2 starting..." | tee -a "$LOG_FILE"

if [[ ! -d "$WEB_DIR" ]]; then
    echo "Error: $WEB_DIR not found!" | tee -a "$LOG_FILE"
    exit 1
fi

main_scan

echo "Scan complete! Check $LOG_FILE for details." | tee -a "$LOG_FILE"