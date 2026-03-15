#!/data/data/com.termux/files/usr/bin/bash

# Link Checker Soul - Comprehensive Link Validation System
# Scans all HTML files for broken links and generates health reports

set -e

# Configuration
WEB_DIR="web-ecosystem"
REPORT_DIR="link-reports"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$REPORT_DIR/link-check-$TIMESTAMP.log"
HEALTH_JSON="$REPORT_DIR/link-health.json"
LINKS_DB="$REPORT_DIR/links-database.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize
mkdir -p "$REPORT_DIR"
echo "Link Checker Soul starting at $(date)" | tee "$LOG_FILE"

# Function to extract all links from HTML files
extract_links() {
    local file="$1"
    echo -e "${BLUE}Extracting links from $file${NC}" | tee -a "$LOG_FILE"
    
    # Extract href links
    grep -oE 'href="[^"]*"' "$file" 2>/dev/null | sed 's/href="//g' | sed 's/"//g' || true
    
    # Extract src links (images, scripts)
    grep -oE 'src="[^"]*"' "$file" 2>/dev/null | sed 's/src="//g' | sed 's/"//g' || true
    
    # Extract action links (forms)
    grep -oE 'action="[^"]*"' "$file" 2>/dev/null | sed 's/action="//g' | sed 's/"//g' || true
}

# Function to check if URL is reachable
check_url() {
    local url="$1"
    local timeout=10
    
    # Skip anchors, javascript, mailto, tel
    if [[ "$url" =~ ^(#|javascript:|mailto:|tel:) ]]; then
        return 0
    fi
    
    # Convert relative URLs to absolute for external checking
    if [[ "$url" =~ ^https?:// ]]; then
        # External URL - check with curl
        if curl -L --max-time $timeout --silent --head --fail "$url" >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    else
        # Internal URL - check file existence
        local base_dir=$(dirname "$2")
        local full_path
        
        if [[ "$url" =~ ^\/ ]]; then
            # Absolute path from root
            full_path="${WEB_DIR}/plt-press${url}"
        else
            # Relative path
            full_path="${base_dir}/${url}"
        fi
        
        # Remove query params and anchors
        full_path=$(echo "$full_path" | sed 's/[?#].*//')
        
        if [[ -f "$full_path" ]] || [[ -d "$full_path" ]]; then
            return 0
        else
            return 1
        fi
    fi
}

# Function to suggest fixes for common broken links
suggest_fix() {
    local url="$1"
    local file="$2"
    
    # Common Stripe fixes
    if [[ "$url" =~ stripe\.com ]]; then
        echo "  → Check Stripe dashboard for correct product links"
        echo "  → Verify Stripe product IDs in environment"
    fi
    
    # GitHub fixes
    if [[ "$url" =~ github\.com ]]; then
        echo "  → Check repository name and path"
        echo "  → Verify branch (master vs main)"
    fi
    
    # Internal file fixes
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "  → Check file exists: $(dirname "$file")/$url"
        echo "  → Verify relative path is correct"
        
        # Try to find similar files
        local basename=$(basename "$url" .html)
        local similar_files=$(find "$WEB_DIR" -name "*$basename*" -type f | head -3)
        if [[ -n "$similar_files" ]]; then
            echo "  → Similar files found:"
            echo "$similar_files" | sed 's/^/    /'
        fi
    fi
}

# Function to auto-fix common issues
auto_fix() {
    local url="$1"
    local file="$2"
    local fixed_url=""
    
    # Fix common GitHub issues
    if [[ "$url" =~ github\.com.*\/master\/ ]]; then
        fixed_url=$(echo "$url" | sed 's/\/master\//\/main\//')
        echo "  → Auto-fix suggestion: Replace 'master' with 'main'"
        echo "    Old: $url"
        echo "    New: $fixed_url"
    fi
    
    # Fix relative path issues
    if [[ "$url" =~ ^\.\./ ]] && [[ -f "${WEB_DIR}/plt-press/$(basename "$url")" ]]; then
        fixed_url="$(basename "$url")"
        echo "  → Auto-fix suggestion: Simplify relative path"
        echo "    Old: $url"
        echo "    New: $fixed_url"
    fi
    
    # Return suggestion if found
    if [[ -n "$fixed_url" ]]; then
        echo "$fixed_url"
    else
        echo ""
    fi
}

# Main scanning function
scan_all_links() {
    echo -e "${BLUE}=== Link Checker Soul - Full Ecosystem Scan ===${NC}" | tee -a "$LOG_FILE"
    
    local total_files=0
    local total_links=0
    local broken_links=0
    local fixed_links=0
    
    # Initialize JSON reports
    echo "{" > "$HEALTH_JSON"
    echo "  \"timestamp\": \"$(date -Iseconds)\"," >> "$HEALTH_JSON"
    echo "  \"files\": {}," >> "$HEALTH_JSON"
    echo "  \"summary\": {}" >> "$HEALTH_JSON"
    echo "}" >> "$HEALTH_JSON"
    
    echo "{" > "$LINKS_DB"
    echo "  \"links\": {}," >> "$LINKS_DB"
    echo "  \"stats\": {}" >> "$LINKS_DB"
    echo "}" >> "$LINKS_DB"
    
    # Process all HTML files
    while IFS= read -r -d '' file; do
        ((total_files++))
        echo -e "\n${YELLOW}[$total_files] Checking: $file${NC}" | tee -a "$LOG_FILE"
        
        local file_broken=0
        local file_total=0
        
        # Extract and check each link
        while IFS= read -r link; do
            [[ -z "$link" ]] && continue
            ((file_total++))
            ((total_links++))
            
            if check_url "$link" "$file"; then
                echo -e "${GREEN}✓${NC} $link" | tee -a "$LOG_FILE"
            else
                ((broken_links++))
                ((file_broken++))
                echo -e "${RED}✗${NC} $link" | tee -a "$LOG_FILE"
                
                # Suggest fixes
                suggest_fix "$link" "$file" | tee -a "$LOG_FILE"
                
                # Try auto-fix
                local suggested_fix=$(auto_fix "$link" "$file")
                if [[ -n "$suggested_fix" ]] && check_url "$suggested_fix" "$file"; then
                    echo -e "${GREEN}✓ Auto-fix works!${NC}" | tee -a "$LOG_FILE"
                    ((fixed_links++))
                fi
            fi
        done < <(extract_links "$file")
        
        echo "  File summary: $file_total links, $file_broken broken" | tee -a "$LOG_FILE"
        
    done < <(find "$WEB_DIR" -name "*.html" -print0)
    
    # Final summary
    echo -e "\n${BLUE}=== FINAL SUMMARY ===${NC}" | tee -a "$LOG_FILE"
    echo "Files scanned: $total_files" | tee -a "$LOG_FILE"
    echo "Links checked: $total_links" | tee -a "$LOG_FILE"
    echo -e "Broken links: ${RED}$broken_links${NC}" | tee -a "$LOG_FILE"
    echo -e "Auto-fixable: ${GREEN}$fixed_links${NC}" | tee -a "$LOG_FILE"
    
    # Update JSON summary
    sed -i "s/\"summary\": {}/\"summary\": {\"files\": $total_files, \"total_links\": $total_links, \"broken\": $broken_links, \"fixable\": $fixed_links}/" "$HEALTH_JSON"
}

# Function to generate HTML dashboard
generate_dashboard() {
    echo -e "${BLUE}Generating link health dashboard...${NC}"
    
    cat > "link-health.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Link Health Dashboard - PLT Ecosystem</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 20px; background: #0f0f0f; color: #e0e0e0; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { color: #00ff88; margin: 0; font-size: 2.5em; }
        .header p { color: #888; font-size: 1.1em; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: #1a1a1a; padding: 20px; border-radius: 8px; border: 1px solid #333; text-align: center; }
        .stat-card h3 { margin: 0 0 10px 0; font-size: 2em; }
        .stat-card p { margin: 0; color: #888; }
        .healthy { color: #00ff88; }
        .warning { color: #ffaa00; }
        .error { color: #ff4444; }
        .section { background: #1a1a1a; padding: 20px; border-radius: 8px; border: 1px solid #333; margin-bottom: 20px; }
        .section h2 { color: #00ff88; margin-top: 0; }
        .log-viewer { background: #000; padding: 15px; border-radius: 5px; font-family: monospace; font-size: 0.9em; max-height: 400px; overflow-y: auto; }
        .footer { text-align: center; margin-top: 40px; color: #666; }
        .refresh-btn { background: #00ff88; color: #000; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .last-updated { color: #888; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔗 Link Health Dashboard</h1>
            <p>PLT Ecosystem Link Validation Status</p>
            <div class="last-updated">Last Updated: <span id="lastUpdate">Loading...</span></div>
            <button class="refresh-btn" onclick="location.reload()">Refresh Data</button>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3 class="healthy" id="totalFiles">-</h3>
                <p>HTML Files</p>
            </div>
            <div class="stat-card">
                <h3 class="healthy" id="totalLinks">-</h3>
                <p>Total Links</p>
            </div>
            <div class="stat-card">
                <h3 class="error" id="brokenLinks">-</h3>
                <p>Broken Links</p>
            </div>
            <div class="stat-card">
                <h3 class="warning" id="fixableLinks">-</h3>
                <p>Auto-Fixable</p>
            </div>
        </div>
        
        <div class="section">
            <h2>🔍 Recent Scan Results</h2>
            <div class="log-viewer" id="scanResults">
                Loading scan results...
            </div>
        </div>
        
        <div class="section">
            <h2>🛠️ Quick Actions</h2>
            <p>• Run full scan: <code>./link-checker.sh</code></p>
            <p>• View detailed logs: <code>tail -f link-reports/link-check-*.log</code></p>
            <p>• Check specific file: <code>./link-checker.sh [filename]</code></p>
        </div>
        
        <div class="footer">
            <p>Link Checker Soul • Auto-refreshes every 15 minutes</p>
        </div>
    </div>
    
    <script>
        // Load dashboard data
        fetch('link-reports/link-health.json')
            .then(response => response.json())
            .then(data => {
                document.getElementById('lastUpdate').textContent = new Date(data.timestamp).toLocaleString();
                document.getElementById('totalFiles').textContent = data.summary.files || 0;
                document.getElementById('totalLinks').textContent = data.summary.total_links || 0;
                document.getElementById('brokenLinks').textContent = data.summary.broken || 0;
                document.getElementById('fixableLinks').textContent = data.summary.fixable || 0;
            })
            .catch(error => {
                console.error('Error loading health data:', error);
                document.getElementById('lastUpdate').textContent = 'Error loading data';
            });
            
        // Load recent log
        fetch('link-reports/link-check-' + new Date().toISOString().slice(0,10) + '*.log')
            .then(response => response.text())
            .then(data => {
                document.getElementById('scanResults').textContent = data || 'No recent scan results';
            })
            .catch(error => {
                document.getElementById('scanResults').textContent = 'Error loading scan results';
            });
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✓ Dashboard created: link-health.html${NC}"
}

# Function to update links directory
update_links_directory() {
    echo -e "${BLUE}Updating links directory...${NC}"
    
    cat > "links-directory.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Links Directory - PLT Ecosystem</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 20px; background: #0f0f0f; color: #e0e0e0; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { color: #00ff88; margin: 0; font-size: 2.5em; }
        .links-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .site-section { background: #1a1a1a; padding: 20px; border-radius: 8px; border: 1px solid #333; }
        .site-section h2 { color: #00ff88; margin-top: 0; }
        .link-item { padding: 8px 0; border-bottom: 1px solid #333; }
        .link-item:last-child { border-bottom: none; }
        .link-item a { color: #66ccff; text-decoration: none; }
        .link-item a:hover { text-decoration: underline; }
        .status { float: right; font-size: 0.8em; padding: 2px 6px; border-radius: 3px; }
        .status.ok { background: #00ff88; color: #000; }
        .status.broken { background: #ff4444; color: #fff; }
        .status.warning { background: #ffaa00; color: #000; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📂 Links Directory</h1>
            <p>All links across the PLT ecosystem with validation status</p>
        </div>
        
        <div class="links-grid">
            <div class="site-section">
                <h2>🏪 PLT Press Store</h2>
                <div id="pltPressLinks">Loading...</div>
            </div>
            
            <div class="site-section">
                <h2>📝 PLT Blog</h2>
                <div id="pltBlogLinks">Loading...</div>
            </div>
            
            <div class="site-section">
                <h2>🤖 AI Tools Hub</h2>
                <div id="aiToolsLinks">Loading...</div>
            </div>
            
            <div class="site-section">
                <h2>💳 Payment Links</h2>
                <div id="paymentLinks">Loading...</div>
            </div>
            
            <div class="site-section">
                <h2>🔗 External Links</h2>
                <div id="externalLinks">Loading...</div>
            </div>
            
            <div class="site-section">
                <h2>📱 Social & GitHub</h2>
                <div id="socialLinks">Loading...</div>
            </div>
        </div>
    </div>
    
    <script>
        // This will be populated by the link checker script
        // with actual link data and validation results
        console.log('Links directory loaded - data will be populated by link checker');
    </script>
</body>
</html>
EOF
    
    echo -e "${GREEN}✓ Links directory created: links-directory.html${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}Link Checker Soul activated! 💀🔗${NC}"
    
    # Check if web ecosystem exists
    if [[ ! -d "$WEB_DIR" ]]; then
        echo -e "${RED}Error: $WEB_DIR directory not found!${NC}"
        echo "Please ensure the web ecosystem is cloned first."
        exit 1
    fi
    
    # Run the scan
    scan_all_links
    
    # Generate reports
    generate_dashboard
    update_links_directory
    
    echo -e "${GREEN}✓ Link checking complete! Reports generated.${NC}"
    echo -e "View dashboard: ${BLUE}link-health.html${NC}"
    echo -e "View directory: ${BLUE}links-directory.html${NC}"
    echo -e "View logs: ${BLUE}$LOG_FILE${NC}"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi