#!/usr/bin/env bash
# PRODUCT SOUL - Data-driven product manifest architect
# MISSION: Discover and package real content factory assets into products.

CONTENT_DIR="/app/plt-content"
MANIFEST_FILE="/app/product-manifest.json"

echo "📦 PRODUCT SOUL: Discovering real digital assets from content factory..."

# Function to extract title from markdown
extract_title() {
    head -n 1 "$1" | sed 's/^# //g' | xargs
}

# Create temp files for JSON arrays
BLOGS_TMP=$(mktemp)
COURSES_TMP=$(mktemp)

echo "[" > "$BLOGS_TMP"
FIRST=true
while IFS= read -r file; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo "," >> "$BLOGS_TMP"; fi
    TITLE=$(extract_title "$file")
    echo "{\"title\": \"$TITLE\", \"file\": \"$(basename "$file")\"}" >> "$BLOGS_TMP"
done < <(find "$CONTENT_DIR/blog" -name "*.md")
echo "]" >> "$BLOGS_TMP"

echo "[" > "$COURSES_TMP"
FIRST=true
while IFS= read -r file; do
    if [ "$FIRST" = true ]; then FIRST=false; else echo "," >> "$COURSES_TMP"; fi
    TITLE=$(extract_title "$file")
    echo "{\"title\": \"$TITLE\", \"file\": \"$(basename "$file")\"}" >> "$COURSES_TMP"
done < <(find "$CONTENT_DIR/course-content" -name "*.md")
echo "]" >> "$COURSES_TMP"

# Construct the manifest using Node
node -e "
const fs = require('fs');
const blogs = JSON.parse(fs.readFileSync('$BLOGS_TMP', 'utf8'));
const courses = JSON.parse(fs.readFileSync('$COURSES_TMP', 'utf8'));

const manifest = {
    last_scan: new Date().toISOString(),
    catalog: {
        educational_articles: blogs,
        curriculum_modules: courses
    },
    packaging_proposals: [
        {
            name: 'PLT Doctrine E-Book',
            components: blogs.map(b => b.title),
            readiness: '90%',
            profit_tier: 'CORE'
        },
        {
            name: 'PLT Certification Curriculum',
            components: courses.map(c => c.title),
            readiness: 'READY',
            profit_tier: 'PREMIUM'
        }
    ]
};

fs.writeFileSync('$MANIFEST_FILE', JSON.stringify(manifest, null, 2));
console.log('✅ Grounded Product Manifest updated with ' + (blogs.length + courses.length) + ' real assets.');
"

rm "$BLOGS_TMP" "$COURSES_TMP"
echo "✅ Product Discovery complete: $MANIFEST_FILE"
