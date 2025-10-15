#!/bin/bash
# ===============================================
# Generate Markdown table from CSS icons
# - Extracts unique base class names (ignores -8, -16, -32, etc.)
# - Outputs a Markdown table with fixed size columns
# ===============================================

# --- Parse arguments ---
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --input|-i) INPUT_FILE="$2"; shift 2 ;;
    --output|-o) OUTPUT_FILE="$2"; shift 2 ;;
    -h|--help)
      echo "[MD] Usage: $0 --input <css-file> --output <md-file>"
      exit 0 ;;
    *)
      echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

# --- Validate ---
if [[ -z "${INPUT_FILE:-}" || -z "${OUTPUT_FILE:-}" ]]; then
  echo "[MD] Error: --input and --output required"
  exit 1
fi
if [[ ! -f "$INPUT_FILE" ]]; then
  echo "[MD] Input file not found: $INPUT_FILE"
  exit 1
fi

# --- Clear output file ---
> "$OUTPUT_FILE"

# --- Markdown header ---
echo "\
---
layout: page
title: Icons
exclude: true
---
| Name | 8 | 16 | 32 | 64 | 128 | 256 |
|------|---|----|----|----|-----|-----|\
" >> "$OUTPUT_FILE"

# --- Extract unique base class names ---
# 1. Grep for lines starting with '.', capture class name before '{'
# 2. Remove trailing -<number>
# 3. Remove leading dot
# 4. Sort uniquely
BASE_CLASSES=($(grep -oE '^\.[a-zA-Z0-9_-]+-[0-9]+' "$INPUT_FILE" | sed -E 's/-[0-9]+$//' | sed 's/^\.//' | sort -u))

# --- Generate Markdown rows ---
for CLASS in "${BASE_CLASSES[@]}"; do
  echo "| $CLASS | <i class='$CLASS-8'></i> | <i class='$CLASS-16'></i> | <i class='$CLASS-32'></i> | <i class='$CLASS-64'></i> | <i class='$CLASS-128'></i> | <i class='$CLASS-256'></i> |" >> "$OUTPUT_FILE"
  echo "[MD] $CLASS"
done

echo "[MD] Complete $OUTPUT_FILE"