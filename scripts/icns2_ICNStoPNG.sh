#!/bin/bash
# ===============================================
# Converts an input folder of ICNS files into PNG files in the output folder
# Works with filenames that contain spaces
# Accepts arguments: --input/-i and --output/-o
# ===============================================

# --- Parse arguments ---
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --input|-i)
      INPUT_DIR="$2"
      shift 2
      ;;
    --output|-o)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -h|--help)
      echo "[ICNS] Usage: $0 --input <input-folder> --output <output-folder>"
      exit 0
      ;;
    *)
      echo "[ICNS] Unknown parameter: $1"
      echo "[ICNS] Use --help for usage instructions."
      exit 1
      ;;
  esac
done

# --- Validate arguments ---
if [[ -z "$INPUT_DIR" || -z "$OUTPUT_DIR" ]]; then
  echo "[ICNS] Error: --input and --output arguments are required."
  exit 1
fi

# --- Ensure output directory exists ---
mkdir -p "$OUTPUT_DIR"

# --- Expand to absolute paths ---
INPUT_DIR=$(cd "$INPUT_DIR" && pwd)
OUTPUT_DIR=$(cd "$OUTPUT_DIR" && pwd)

# --- Process ICNS files ---
shopt -s nullglob
for f in "$INPUT_DIR"/*.icns; do
  base=$(basename "$f" .icns)
  echo "[ICNS] $base"
  mkdir -p "$OUTPUT_DIR/$base.iconset"
  iconutil --convert iconset "$f" --output "$OUTPUT_DIR/$base.iconset"
done

echo "[ICNS] Complete $OUTPUT_DIR"