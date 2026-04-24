#!/usr/bin/env bash
# matilha sigil renderer
#
# Prints the matilha pack sigil to stdout. Called by matilha-compose at
# activation to display the sigil directly without LLM reproduction.
#
# Lookup order for sigil source:
#   1. MATILHA_SIGIL_PATH env var (user override)
#   2. $PLUGIN_ROOT/assets/sigil.txt (default shipped asset)
#   3. Embedded fallback (if no file available)
#
# Replace assets/sigil.txt with your ascii-image-converter output any time.
# Suggested generation:
#   ascii-image-converter input.png --width 30 > assets/sigil.txt
#   ascii-image-converter input.png --width 35 --complex > assets/sigil.txt
#   ascii-image-converter input.png --width 35 --complex --dither > assets/sigil.txt
#
# Constraints for the image that will render well:
#   - Width <= 40 columns (safe across terminals + mobile)
#   - Height <= 15 rows (doesn't dominate conversation)
#   - Consistent line widths (avoid trailing-space trimming issues)
#   - Plain ASCII or widely supported UTF-8 (avoid braille for LLM-adjacent display)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SIGIL_FILE="${MATILHA_SIGIL_PATH:-${PLUGIN_ROOT}/assets/sigil.txt}"

if [ -f "$SIGIL_FILE" ]; then
  cat "$SIGIL_FILE"
  exit 0
fi

# Embedded fallback — used only if assets/sigil.txt is missing.
cat << 'EOF'
            ♛
        /\___/\
       ( ◉   ◉ )
        \  v  /
         ‾‾‾‾‾

   /\_/\   /\_/\   /\_/\
  ( ● ● ) ( ● ● ) ( ● ● )
    \/      \/      \/
          matilha
EOF
