#!/usr/bin/env bash
# ===============================================
# 🔍 Find and copy all .icns files
# - Searches from a specified root (--find-root)
# - Skips the output folder so copied files won't be re-found
# - Renames files to path-safe names using '-'
# - Saves results to the specified output folder
# ===============================================

set -euo pipefail

# --- Parse arguments ---
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --find-root|-f)
      FIND_ROOT="$2"
      shift 2
      ;;
    --output|-o)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 --find-root <search-root> --output <output-folder>"
      exit 0
      ;;
    *)
      echo "❌ Unknown parameter: $1"
      echo "Use --help for usage instructions."
      exit 1
      ;;
  esac
done

# --- Validate arguments ---
if [[ -z "${FIND_ROOT:-}" || -z "${OUTPUT_DIR:-}" ]]; then
  echo "❌ Error: --find-root and --output arguments are required."
  exit 1
fi

# --- Expand to absolute paths ---
FIND_ROOT=$(cd "$FIND_ROOT" && pwd)
OUTPUT_DIR=$(cd "$OUTPUT_DIR" && pwd)

# --- Ensure output directory exists ---
mkdir -p "$OUTPUT_DIR"

echo "🚀 Searching for .icns files from: $FIND_ROOT"
echo "Output directory: $OUTPUT_DIR (will be skipped)"

# --- Find and copy ICNS files ---
find "$FIND_ROOT" \
  -path "$OUTPUT_DIR" -prune -o \
  -type f -name "*.icns" -print0 2>/dev/null |
while IFS= read -r -d '' f; do

  # Convert path to filename-safe format:
  clean_name=$(echo "$f" | sed 's#/#-#g; s#^-##')

  dest="$OUTPUT_DIR/$clean_name"

  # Copy the file, skip if exists
  if cp -n "$f" "$dest" 2>/dev/null; then
    echo "✅ Copied: $f"
  else
    echo "⚠️ Failed Copy: $f"
  fi
done

echo "🎉 Done! All .icns files (that could be copied) are in: $OUTPUT_DIR"