#!/data/data/com.termux/files/usr/bin/bash

# Simple test version of link checker

echo "Testing link extraction..."

# Find first HTML file
first_file=$(find web-ecosystem -name "*.html" | head -1)
echo "Testing file: $first_file"

if [[ -f "$first_file" ]]; then
    echo "Extracting links..."
    
    # Extract href links
    echo "=== HREF LINKS ==="
    grep -oE 'href="[^"]*"' "$first_file" 2>/dev/null | sed 's/href="//g' | sed 's/"//g' | head -10
    
    echo "=== SRC LINKS ==="
    grep -oE 'src="[^"]*"' "$first_file" 2>/dev/null | sed 's/src="//g' | sed 's/"//g' | head -10
    
else
    echo "No HTML files found!"
fi