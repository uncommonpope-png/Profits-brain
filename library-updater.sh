#!/bin/bash
# LIBRARY UPDATER - Discovers and catalogs all ecosystem pages with clickable links

LIBRARY_LOG="$HOME/.openclaw/workspace/library-updater.log"
BASE_PATH="/data/data/com.termux/files/home/repos"

echo "📚 LIBRARY UPDATER ACTIVATED - Cataloging Ecosystem"
echo "Started: $(date) | PID: $$ | Mission: Discover All Pages"

while true; do
    {
        echo "[$(date)] 📚 LIBRARY UPDATE CYCLE"
        
        # 1. DISCOVER ALL HTML PAGES ACROSS ECOSYSTEM
        echo "🔍 Scanning all repositories for pages..."
        
        cd "$BASE_PATH" || exit 1
        
        # Initialize page collections
        MAIN_PAGES=""
        BLOG_PAGES=""
        PRODUCT_PAGES=""
        TOOLS_PAGES=""
        SEO_PAGES=""
        REVENUE_PAGES=""
        SYSTEM_PAGES=""
        
        # Scan PLT Press main
        if [ -d "plt-press" ]; then
            cd plt-press
            echo "📄 Scanning plt-press..."
            
            for file in *.html; do
                if [ -f "$file" ]; then
                    TITLE=$(grep -o '<title>[^<]*</title>' "$file" 2>/dev/null | sed 's/<[^>]*>//g' | head -1)
                    [ -z "$TITLE" ] && TITLE="$file"
                    WORDS=$(wc -w < "$file" 2>/dev/null || echo "0")
                    
                    # Categorize by filename patterns
                    case "$file" in
                        dashboard.html|index.html|vault.html|teacher.html|health.html|ticker.html|souls.html|djinie.html|deerg-bot.html|doctor-buht-buht.html|seo-dashboard.html)
                            SYSTEM_PAGES="$SYSTEM_PAGES|$file|$TITLE|$WORDS"
                            ;;
                        ai-*|automate-*|business-*|credit-*|financial-*)
                            SEO_PAGES="$SEO_PAGES|$file|$TITLE|$WORDS"
                            ;;
                        plt-score-*|free-chapter*|ai-services*)
                            REVENUE_PAGES="$REVENUE_PAGES|$file|$TITLE|$WORDS"
                            ;;
                        *)
                            MAIN_PAGES="$MAIN_PAGES|$file|$TITLE|$WORDS"
                            ;;
                    esac
                fi
            done
            
            # Scan products directory
            if [ -d "products" ]; then
                for file in products/*.html; do
                    if [ -f "$file" ]; then
                        TITLE=$(grep -o '<title>[^<]*</title>' "$file" 2>/dev/null | sed 's/<[^>]*>//g' | head -1)
                        [ -z "$TITLE" ] && TITLE="$(basename "$file")"
                        WORDS=$(wc -w < "$file" 2>/dev/null || echo "0")
                        PRODUCT_PAGES="$PRODUCT_PAGES|$file|$TITLE|$WORDS"
                    fi
                done
            fi
            cd ..
        fi
        
        # Scan PLT Blog
        if [ -d "plt-blog" ]; then
            cd plt-blog
            echo "📝 Scanning plt-blog..."
            
            for file in *.html; do
                if [ -f "$file" ]; then
                    TITLE=$(grep -o '<title>[^<]*</title>' "$file" 2>/dev/null | sed 's/<[^>]*>//g' | head -1)
                    [ -z "$TITLE" ] && TITLE="$file"
                    WORDS=$(wc -w < "$file" 2>/dev/null || echo "0")
                    BLOG_PAGES="$BLOG_PAGES|$file|$TITLE|$WORDS"
                fi
            done
            cd ..
        fi
        
        # Scan AI Tools Hub
        if [ -d "ai-tools-hub" ]; then
            cd ai-tools-hub
            echo "🛠️ Scanning ai-tools-hub..."
            
            for file in *.html; do
                if [ -f "$file" ]; then
                    TITLE=$(grep -o '<title>[^<]*</title>' "$file" 2>/dev/null | sed 's/<[^>]*>//g' | head -1)
                    [ -z "$TITLE" ] && TITLE="$file"
                    WORDS=$(wc -w < "$file" 2>/dev/null || echo "0")
                    TOOLS_PAGES="$TOOLS_PAGES|$file|$TITLE|$WORDS"
                fi
            done
            cd ..
        fi
        
        # Count totals
        SYSTEM_COUNT=$(echo "$SYSTEM_PAGES" | grep -o "|" | wc -l)
        MAIN_COUNT=$(echo "$MAIN_PAGES" | grep -o "|" | wc -l)
        BLOG_COUNT=$(echo "$BLOG_PAGES" | grep -o "|" | wc -l)
        PRODUCT_COUNT=$(echo "$PRODUCT_PAGES" | grep -o "|" | wc -l)
        TOOLS_COUNT=$(echo "$TOOLS_PAGES" | grep -o "|" | wc -l)
        SEO_COUNT=$(echo "$SEO_PAGES" | grep -o "|" | wc -l)
        REVENUE_COUNT=$(echo "$REVENUE_PAGES" | grep -o "|" | wc -l)
        TOTAL_COUNT=$((SYSTEM_COUNT + MAIN_COUNT + BLOG_COUNT + PRODUCT_COUNT + TOOLS_COUNT + SEO_COUNT + REVENUE_COUNT))
        
        echo "📊 Discovered $TOTAL_COUNT total pages"
        
        # 2. UPDATE DASHBOARD WITH LIBRARY DATA
        echo "📋 Updating library data..."
        
        cd plt-press 2>/dev/null && node -e "
        const fs=require('fs');
        const d=JSON.parse(fs.readFileSync('log.json','utf8'));
        d.updated=new Date().toISOString();
        
        d.library_catalog = {
            last_scan: new Date().toISOString(),
            total_pages: $TOTAL_COUNT,
            categories: {
                system: {
                    count: $SYSTEM_COUNT,
                    pages: '$SYSTEM_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                main: {
                    count: $MAIN_COUNT,
                    pages: '$MAIN_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                blog: {
                    count: $BLOG_COUNT,
                    pages: '$BLOG_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                products: {
                    count: $PRODUCT_COUNT,
                    pages: '$PRODUCT_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                tools: {
                    count: $TOOLS_COUNT,
                    pages: '$TOOLS_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                seo: {
                    count: $SEO_COUNT,
                    pages: '$SEO_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                },
                revenue: {
                    count: $REVENUE_COUNT,
                    pages: '$REVENUE_PAGES'.split('|').filter(p => p.trim()).reduce((acc, page, i, arr) => {
                        if (i % 3 === 0 && arr[i+1] && arr[i+2]) {
                            acc.push({file: page, title: arr[i+1], words: parseInt(arr[i+2]) || 0});
                        }
                        return acc;
                    }, [])
                }
            }
        };
        
        // Add Library Updater to ticker if not already there
        let libIndex = d.ticker.findIndex(t => t.soul === 'Library Updater');
        if (libIndex >= 0) {
            d.ticker[libIndex].action = 'CATALOG: $TOTAL_COUNT pages across ecosystem';
        } else {
            d.ticker.unshift({
                soul: 'Library Updater',
                emoji: '📚',
                action: 'CATALOG: $TOTAL_COUNT pages across ecosystem',
                status: 'cataloging'
            });
        }
        
        fs.writeFileSync('log.json',JSON.stringify(d,null,2));
        console.log('📚 Library catalog updated - $TOTAL_COUNT pages');
        " 2>/dev/null && git add log.json && git commit -m "Library: Catalog update - $TOTAL_COUNT pages" && git push 2>&1
        
        echo "[$(date)] ✅ Library update complete - next scan in 10 minutes"
        
    } >> "$LIBRARY_LOG" 2>&1
    
    # Keep log manageable
    tail -200 "$LIBRARY_LOG" > "${LIBRARY_LOG}.tmp" && mv "${LIBRARY_LOG}.tmp" "$LIBRARY_LOG"
    
    # Scan every 10 minutes
    sleep 600
done