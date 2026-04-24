# Assets

## Sigil variants

Three pre-rendered ASCII sigils generated from the matilha logo via [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter):

| File | Width | Height | Best for |
|---|---|---|---|
| `sigil-w50.txt` | 50 cols | 25 rows | Compact (every-turn, low footprint) |
| **`sigil.txt`** (= `sigil-w60.txt`) | 60 cols | 30 rows | **Default — balanced visibility** |
| `sigil-w60.txt` | 60 cols | 30 rows | Same as `sigil.txt` (kept for clarity) |
| `sigil-w80.txt` | 80 cols | 40 rows | Hero / README banner — tagline "YOU LEAD. AGENTS HUNT!" fully visible |

The file loaded by `hooks/print-sigil.sh` is always `sigil.txt`. Swap the default by copying a different variant into place:

```bash
# Use the compact version:
cp assets/sigil-w50.txt assets/sigil.txt

# Use the full-size version with tagline:
cp assets/sigil-w80.txt assets/sigil.txt

# Commit the change:
git add assets/sigil.txt
git commit -m "chore(sigil): switch default sigil to W<N> variant"
```

## One-off override (no file swap)

If you want to test a different sigil without committing, use the `MATILHA_SIGIL_PATH` env var:

```bash
MATILHA_SIGIL_PATH=/tmp/custom-sigil.txt bash hooks/print-sigil.sh
```

## Regenerating sigils from a new logo

The canonical render command for matilha logos (white subject on black background):

```
ascii-image-converter <img> -W <width> -n -m " .#"
```

- `-n` inverts polarity so white wolves render as light chars (readable instantly)
- `-m " .#"` uses a clean 3-char palette (solid `#`, sparse `.`, blank) — avoids `@:=+` noise from the default palette
- `-W <width>` sets width; height auto-follows aspect ratio

Regenerate all three sizes at once:

```bash
SRC=./assets/new-logo.png

ascii-image-converter "$SRC" -W 50 -n -m " .#" > assets/sigil-w50.txt
ascii-image-converter "$SRC" -W 60 -n -m " .#" > assets/sigil-w60.txt
ascii-image-converter "$SRC" -W 80 -n -m " .#" > assets/sigil-w80.txt

# Promote new W60 as default:
cp assets/sigil-w60.txt assets/sigil.txt

# Verify width consistency (each variant should show one number):
for f in assets/sigil*.txt; do
  echo "$f: widths = $(awk '{ print length }' "$f" | sort -u | tr '\n' ' ')"
done
```

### If your logo is dark on light background

Drop the `-n` flag:

```bash
ascii-image-converter "$SRC" -W 60 -m " .#" > assets/sigil-w60.txt
```

### If you want a richer palette (for photographic logos)

```bash
ascii-image-converter "$SRC" -W 60 -n -m " .:-+#" > assets/sigil-w60.txt
```

### If you want maximum density (terminal must support UTF-8 braille)

```bash
ascii-image-converter "$SRC" -W 60 -n -b --dither > assets/sigil-w60.txt
```

## Banner image (for README hero)

When you generate a banner image, save it as:

```
assets/matilha-banner.png
```

Then uncomment the image line in the root `README.md`:

```markdown
![matilha banner](./assets/matilha-banner.png)
```

**Suggested dimensions**: 1280×400 px (3.2:1 ratio) or 1920×600 px for high-DPI.

**Visual brand cues** (to inform image generation):
- Pack metaphor — wolves in formation OR alpha wolf with crown
- Typography — matilha tagline "You lead. Agents hunt." bold and readable
- Palette — dark background (forest/night) with warm accent for crown
- Optional: small ASCII sigil rendering in the corner as easter egg

## Future

- `assets/demo.gif` — record a ~15s demo of sigil + brainstorming flow
- `assets/architecture.png` — diagram of composition layer
- `assets/pack-map.png` — visual map of 7 packs
