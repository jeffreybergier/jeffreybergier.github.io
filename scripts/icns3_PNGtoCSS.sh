#!/bin/bash
# ===============================================
# 🧩 Generate CSS for icons from PNGs
# - Accepts arguments: --root, --input, --output
# - Creates retina-sharp CSS with half-size dimensions
# - Preserves folder names (no cleaning)
# - Alphabetizes icons with numeric awareness
# - Escapes dots in CSS class names
# - Strips root path from URLs
# ===============================================

# --- Parse arguments ---
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --root|-r)
      ROOT_DIR="$2"
      shift 2
      ;;
    --input|-i)
      INPUT_DIR="$2"
      shift 2
      ;;
    --output|-o)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "[CSS] Usage: $0 --root <root-directory> --input <input-directory> --output <output-file>"
      exit 0
      ;;
    *)
      echo "[CSS] Unknown parameter: $1"
      echo "[CSS] Use --help for usage instructions."
      exit 1
      ;;
  esac
done

# --- Validate arguments ---
if [[ -z "$ROOT_DIR" || -z "$INPUT_DIR" || -z "$OUTPUT_FILE" ]]; then
  echo "[CSS] Error: --root, --input, and --output arguments are required."
  exit 1
fi

# --- Expand to absolute paths ---
ROOT_DIR=$(cd "$ROOT_DIR" && pwd)
INPUT_DIR=$(cd "$INPUT_DIR" && pwd)
OUTPUT_FILE=$(cd "$(dirname "$OUTPUT_FILE")" && pwd)/$(basename "$OUTPUT_FILE")

# --- Clear output file ---
> "$OUTPUT_FILE"

# --- Generate CSS ---
find "$INPUT_DIR" -mindepth 2 -type f -name "*.png" | sort -V | while IFS= read -r f; do
  folder=$(basename "$(dirname "$f")" .iconset)
  base=$(basename "$f" .png)

  width=$(sips -g pixelWidth "$f" | awk '/pixelWidth/ {print $2}')
  height=$(sips -g pixelHeight "$f" | awk '/pixelHeight/ {print $2}')

  half_width=$((width / 2))
  half_height=$((height / 2))

  # Escape dots for CSS class names
  escaped_folder=$(echo "$folder" | sed 's/\./\\./g')

  # Remove the root directory prefix from the full path for web use
  rel_path="${f#$ROOT_DIR}"
  web_path="${rel_path#./}"  # ensure leading slash, no ./ prefix

  {
    echo ".$escaped_folder-$half_width {"
    echo "  display: inline-block;"
    echo "  width: ${half_width}px;"
    echo "  height: ${half_height}px;"
    echo "  background-image: url('$web_path');"
    echo "  background-size: ${half_width}px ${half_height}px;"
    echo "  background-repeat: no-repeat;"
    echo "  background-position: center;"
    echo "}"
    echo ""
  } >> "$OUTPUT_FILE"

  echo "[CSS] .$folder-$half_width (${half_width}×${half_height})"
done

echo "[CSS] Complete $OUTPUT_FILE"
