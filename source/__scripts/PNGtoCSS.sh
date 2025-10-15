#!/bin/bash
# ===============================================
# 🧩 Generate CSS for icons from PNGs
# - Scans ./assets/icons/*/*.png
# - Creates retina-sharp CSS with half-size dimensions
# - Preserves original folder names (no cleaning)
# - Alphabetizes icons with numeric awareness
# ===============================================

output="./assets/css/_icons.scss"
echo "/* Auto-Generated Stylesheet for Icons */" > "$output"

find ./assets/icons -mindepth 2 -type f -name "*.png" | sort -V | while IFS= read -r f; do
  folder=$(basename "$(dirname "$f")" .iconset)
  base=$(basename "$f" .png)

  width=$(sips -g pixelWidth "$f" | awk '/pixelWidth/ {print $2}')
  height=$(sips -g pixelHeight "$f" | awk '/pixelHeight/ {print $2}')

  half_width=$((width / 2))
  half_height=$((height / 2))

  # Convert to web path
  web_path="/${f#./}"  # strips leading ./ and adds leading /

  echo ".icon-$folder-$half_width {" >> "$output"
  echo "  display: inline-block;" >> "$output"
  echo "  width: ${half_width}px;" >> "$output"
  echo "  height: ${half_height}px;" >> "$output"
  echo "  background-image: url('$web_path');" >> "$output"
  echo "  background-size: ${half_width}px ${half_height}px;" >> "$output"
  echo "  background-repeat: no-repeat;" >> "$output"
  echo "  background-position: center;" >> "$output"
  echo "}" >> "$output"
  echo "" >> "$output"

  echo "✅ Added .icon-$folder-$half_width (${half_width}×${half_height})"
done

echo "🎉 CSS written to $output"