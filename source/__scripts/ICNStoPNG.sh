#!/bin/bash
# ===============================================
# Converts an input folder of ICNS files into PNG files in the output folder
# ===============================================

for f in ./input/*.icns; do
  base=$(basename "$f" .icns)
  
  # Convert to lowercase and replace _ with -
  cleanname=$(echo "$base" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
  
  echo "Extracting $cleanname..."
  
  mkdir -p ./output/"$cleanname".iconset
  iconutil --convert iconset "$f" --output ./output/"$cleanname".iconset
done