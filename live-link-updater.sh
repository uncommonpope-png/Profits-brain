#!/bin/bash
# LIVE LINK UPDATER - Instantly updates links directory with new content
# Mission: Detect new content and add clickable links immediately

LINK_LOG="$HOME/.openclaw/workspace/live-link-updater.log"
PLT_PATH="/data/data/com.termux/files/home/repos/plt-press"
BASE_PATH="/data/data/com.termux/files/home/repos"
LINKS_FILE="$PLT_PATH/live-links.json"
SEEN_FILES="$HOME/.openclaw/workspace/.seen-files.txt"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}🔗 LIVE LINK UPDATER ACTIVATED${NC}"
echo "Mission: Instant link detection and cataloging"

# Initialize seen files if doesn't exist
touch "$SEEN_FILES"

while true; do
    {
        echo "[$(date)] 🔍 Scanning for new content..."
        
        # Find all HTML files across ecosystem
        NEW_CONTENT_FOUND=false
        ALL_LINKS='{"updated": "'$(date -Iseconds)'", "categories": {"main": [], "blog": [], "seo": [], "products": [], "tools": [], "system": []}}'
        
        cd "$BASE_PATH" || exit 1
        
        # Scan all repositories
        for repo in plt-press plt-blog ai-tools-hub; do
            if [ -d "$repo" ]; then
                cd "$repo"
                echo -e "${CYAN}📂 Scanning $repo${NC}"
                
                for file in *.html; do
                    if [ -f "$file" ]; then
                        FULL_PATH="$PWD/$file"
                        
                        # Check if this is a new file
                        if ! grep -q "$FULL_PATH" "$SEEN_FILES"; then
                            NEW_CONTENT_FOUND=true
                            echo "$FULL_PATH" >> "$SEEN_FILES"
                            echo -e "${YELLOW}🆕 NEW CONTENT: $file${NC}"
                        fi
                        
                        # Extract metadata
                        TITLE=$(grep -o '<title>[^<]*</title>' "$file" 2>/dev/null | sed 's/<[^>]*>//g' | head -1)
                        DESCRIPTION=$(grep -o '<meta name="description" content="[^"]*"' "$file" 2>/dev/null | sed 's/.*content="//; s/".*//' | head -1)
                        WORDS=$(wc -w < "$file" 2>/dev/null || echo "0")
                        SIZE=$(stat -c%s "$file" 2>/dev/null || echo "0")
                        
                        # Default title if none found
                        [ -z "$TITLE" ] && TITLE="$(basename "$file" .html | tr '-' ' ' | sed 's/\b\w/\u&/g')"
                        [ -z "$DESCRIPTION" ] && DESCRIPTION="Page content from $repo"
                        
                        # Determine category
                        CATEGORY="main"
                        case "$file" in
                            dashboard.html|vault.html|ticker.html|souls.html|*-bot*.html|seo-dashboard.html)
                                CATEGORY="system" ;;
                            ai-*|automate-*|business-*|credit-*|financial-*)
                                CATEGORY="seo" ;;
                            *product*|*service*|plt-score*|*chapter*)
                                CATEGORY="products" ;;
                        esac
                        
                        # Special handling for blog repo
                        [ "$repo" = "plt-blog" ] && CATEGORY="blog"
                        [ "$repo" = "ai-tools-hub" ] && CATEGORY="tools"
                        
                        # Build URL (GitHub Pages format)
                        if [ "$repo" = "plt-press" ]; then
                            URL="https://uncommonpope-png.github.io/plt-press/$file"
                        elif [ "$repo" = "plt-blog" ]; then
                            URL="https://uncommonpope-png.github.io/plt-blog/$file"
                        elif [ "$repo" = "ai-tools-hub" ]; then
                            URL="https://uncommonpope-png.github.io/ai-tools-hub/$file"
                        fi
                        
                        # Add to links collection using Node.js
                        node -e "
                        const links = $ALL_LINKS;
                        links.categories['$CATEGORY'].push({
                            title: \`$TITLE\`,
                            description: \`$DESCRIPTION\`,
                            url: \`$URL\`,
                            file: \`$file\`,
                            repo: \`$repo\`,
                            words: $WORDS,
                            size: $SIZE,
                            last_modified: '$(stat -c%y "$file" 2>/dev/null || date -Iseconds)'
                        });
                        console.log(JSON.stringify(links));
                        " > "${LINKS_FILE}.tmp" && mv "${LINKS_FILE}.tmp" "$LINKS_FILE"
                        
                        ALL_LINKS=$(cat "$LINKS_FILE")
                    fi
                done
                cd ..
            fi
        done
        
        # Calculate totals and update main dashboard
        TOTAL_LINKS=$(node -e "
        const links = JSON.parse(require('fs').readFileSync('$LINKS_FILE', 'utf8'));
        let total = 0;
        Object.values(links.categories).forEach(cat => total += cat.length);
        console.log(total);
        ")
        
        echo "📊 Total links cataloged: $TOTAL_LINKS"
        
        # Update main dashboard with links data
        cd "$PLT_PATH"
        if [ -f "log.json" ]; then
            node -e "
            const fs = require('fs');
            const data = JSON.parse(fs.readFileSync('log.json', 'utf8'));
            const links = JSON.parse(fs.readFileSync('$LINKS_FILE', 'utf8'));
            
            data.live_links = {
                total: $TOTAL_LINKS,
                categories: Object.keys(links.categories).reduce((acc, cat) => {
                    acc[cat] = links.categories[cat].length;
                    return acc;
                }, {}),
                last_updated: new Date().toISOString()
            };
            
            // Update ticker
            let linkIndex = data.ticker.findIndex(t => t.soul === 'Link Updater');
            if (linkIndex >= 0) {
                data.ticker[linkIndex].action = 'LINKS: $TOTAL_LINKS cataloged, instant updates';
            } else {
                data.ticker.push({
                    soul: 'Link Updater',
                    emoji: '🔗',
                    action: 'LINKS: $TOTAL_LINKS cataloged, instant updates',
                    status: 'cataloging'
                });
            }
            
            fs.writeFileSync('log.json', JSON.stringify(data, null, 2));
            console.log('🔗 Links updated in dashboard');
            " 2>/dev/null
            
            # Commit if new content was found
            if [ "$NEW_CONTENT_FOUND" = true ]; then
                git add log.json "$LINKS_FILE" 2>/dev/null
                git commit -m "LIVE LINKS: New content detected, catalog updated" >/dev/null 2>&1
                git push >/dev/null 2>&1 &
                echo -e "${GREEN}📤 New links pushed live${NC}"
            fi
        fi
        
        echo "[$(date)] ✅ Link scan complete - next scan in 60 seconds"
        
    } >> "$LINK_LOG" 2>&1
    
    # Keep log manageable
    tail -200 "$LINK_LOG" > "${LINK_LOG}.tmp" && mv "${LINK_LOG}.tmp" "$LINK_LOG"
    
    # Scan every minute for instant updates
    sleep 60
done