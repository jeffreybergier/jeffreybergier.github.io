#!/bin/bash
# ===============================================
# Converts an input folder of ICNS files into PNG files in the output folder
# Works with filenames that contain spaces
# ===============================================

for f in ./input/*.icns; do
  base=$(basename "$f" .icns)
  echo "Extracting \"$base\"..."
  mkdir -p "./output/$base.iconset"
  iconutil --convert iconset "$f" --output "./output/$base.iconset"
done