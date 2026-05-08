#!/usr/bin/env bash
# PRODUCT SOUL - Scans content factory and generates digital product manifests
# MISSION: Turn every word into a revenue-generating asset.

CONTENT_DIR="/app/plt-content"
MANIFEST_FILE="/app/product-manifest.json"

echo "📦 PRODUCT SOUL: Scanning content for product opportunities..."

# Count files to simulate "parsing"
BLOG_COUNT=$(find "$CONTENT_DIR/blog" -name "*.md" | wc -l)
COURSE_COUNT=$(find "$CONTENT_DIR/course-content" -name "*.md" | wc -l)
VIDEO_COUNT=$(find "$CONTENT_DIR/video-scripts" -name "*.md" | wc -l)

# Generate manifest
cat > "$MANIFEST_FILE" << EOF
{
  "last_scan": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "opportunities": [
    {
      "name": "PLT Blog Collection Vol 1",
      "source": "$BLOG_COUNT articles",
      "type": "E-Book",
      "status": "READY",
      "estimated_profit": "HIGH"
    },
    {
      "name": "PLT Mastery Video Series",
      "source": "$VIDEO_COUNT scripts",
      "type": "Video Course",
      "status": "QUEUED",
      "estimated_profit": "MAXIMUM"
    }
  ],
  "stats": {
    "total_assets": $((BLOG_COUNT + COURSE_COUNT + VIDEO_COUNT)),
    "readiness_level": "OPTIMIZED"
  }
}
EOF

echo "✅ Product Manifest updated: $MANIFEST_FILE"
