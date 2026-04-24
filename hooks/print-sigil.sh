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
# Canonical generation command (white-on-black logos — the matilha default):
#   ascii-image-converter input.png -W 60 -n -m " .#" > assets/sigil.txt
#
# Flag rationale:
#   -W 60           = width in chars (50 compact / 60 default / 80 hero)
#   -n              = negative; inverts polarity so white subjects on black bg
#                     render as light chars on dark (readable at a glance)
#   -m " .#"        = 3-char palette (dark→light): solid #, sparse dots, blank.
#                     Eliminates @ : = + - visual noise from the default palette.
#
# Alternatives for different source types:
#   Dark subject on light bg:  drop -n, keep -m " .#"
#   Need more gradient levels: -m " .:-+#" (5 chars) for photos / illustrations
#   Ultra-high density:         -W 60 -b --dither (braille; terminal must support UTF-8)
#
# Constraints that keep the render clean:
#   - Width <= 80 columns (safe across modern terminals + wrap-safe in mobile views)
#   - Height <= 40 rows (height auto-follows width via aspect ratio)
#   - Consistent line widths (no trailing-space trimming issues)
#   - Plain ASCII or widely supported UTF-8 (avoid braille for terminals without font)

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
