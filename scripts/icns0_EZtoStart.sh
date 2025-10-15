#!/bin/bash
# ===============================================
# Argument-driven Icon Workflow with Defaults
# - Converts ICNS -> PNG
# - Generates CSS from PNGs
# - Generates Markdown table from CSS
# ===============================================

set -euo pipefail

# --- Determine script directory ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# --- Defaults ---
DEFAULT_WEB_ROOT="$SCRIPT_DIR/../source"
DEFAULT_PNG_OUTPUT="$SCRIPT_DIR/../source/assets/icons"
DEFAULT_CSS_FILE="$SCRIPT_DIR/../source/assets/css/_icons.scss"
DEFAULT_MD_FILE="$SCRIPT_DIR/../source/unlisted/icons.md"

# --- Parse arguments ---
ICNS_INPUT=""
WEB_ROOT="$DEFAULT_WEB_ROOT"
PNG_OUTPUT="$DEFAULT_PNG_OUTPUT"
CSS_FILE="$DEFAULT_CSS_FILE"
MD_FILE="$DEFAULT_MD_FILE"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --input|-i)
      ICNS_INPUT="$2"
      shift 2
      ;;
    --web-root|-r)
      WEB_ROOT="$2"
      shift 2
      ;;
    --png-dir|-p)
      PNG_OUTPUT="$2"
      shift 2
      ;;
    --css-file|-c)
      CSS_FILE="$2"
      shift 2
      ;;
    --md-file|-m)
      MD_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "[ERROR] Usage: $0 --input <ICNS folder> [--web-root <root>] [--png-dir <folder>] [--css-file <file>] [--md-file <file>]"
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown parameter: $1"
      exit 1
      ;;
  esac
done

# --- Validate required arguments ---
if [[ -z "$ICNS_INPUT" ]]; then
  echo "[ERROR] --input <ICNS folder> is required."
  exit 1
fi

# --- Clean paths from backslash spaces (dragged from Finder) ---
ICNS_INPUT=$(echo "$ICNS_INPUT" | sed 's/\\ / /g')
WEB_ROOT=$(echo "$WEB_ROOT" | sed 's/\\ / /g')
PNG_OUTPUT=$(echo "$PNG_OUTPUT" | sed 's/\\ / /g')
CSS_FILE=$(echo "$CSS_FILE" | sed 's/\\ / /g')
MD_FILE=$(echo "$MD_FILE" | sed 's/\\ / /g')

# --- Resolve absolute paths ---
ICNS_INPUT=$(cd "$ICNS_INPUT" && pwd)
WEB_ROOT=$(cd "$WEB_ROOT" && pwd)
mkdir -p "$PNG_OUTPUT"
PNG_OUTPUT=$(cd "$PNG_OUTPUT" && pwd)
mkdir -p "$(dirname "$CSS_FILE")"
CSS_FILE=$(cd "$(dirname "$CSS_FILE")" && pwd)/$(basename "$CSS_FILE")
mkdir -p "$(dirname "$MD_FILE")"
MD_FILE=$(cd "$(dirname "$MD_FILE")" && pwd)/$(basename "$MD_FILE")

echo "
Summary
ICNS_INPUT: $ICNS_INPUT
WEB_ROOT:   $WEB_ROOT
PNG_OUTPUT: $PNG_OUTPUT
CSS_FILE:   $CSS_FILE
MD_FILE:    $MD_FILE
"

# --- Ask for confirmation ---
read -rp "Do you want to proceed? [y/N]: " CONFIRM
CONFIRM=$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')  # convert to lowercase
if [[ "$CONFIRM" != "y" ]]; then
  echo "[ERROR] Aborted"
  exit 0
fi

if ! bash "$SCRIPT_DIR/icns2_ICNStoPNG.sh" --input "$ICNS_INPUT" --output "$PNG_OUTPUT"; then
  echo "[ERROR] icns2_ICNStoPNG.sh"
  exit 1
fi

if ! bash "$SCRIPT_DIR/icns3_PNGtoCSS.sh" --root "$WEB_ROOT" --input "$PNG_OUTPUT" --output "$CSS_FILE"; then
  echo "[ERROR] icns3_PNGtoCSS.sh"
  exit 1
fi

if ! bash "$SCRIPT_DIR/icns4_CSStoMD.sh" --input "$CSS_FILE" --output "$MD_FILE"; then
  echo "[ERROR] icns4_CSStoMD.sh"
  exit 1
fi

