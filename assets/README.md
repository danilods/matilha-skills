# Assets

## Sigil variants

Pre-rendered sigils from the matilha logo via [ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter):

| File | Render | Dimensions | Best for |
|---|---|---|---|
| **`sigil.txt`** (= `sigil-w60.txt`) | **Braille** | 60x30 | **Default — highest visual fidelity** (requires UTF-8 braille font in terminal) |
| `sigil-w60.txt` | Braille | 60x30 | Same as `sigil.txt` (kept for clarity) |
| `sigil-w50.txt` | ASCII `-n -m " .#"` | 50x25 | **Fallback** — compact, works in any terminal |
| `sigil-w80.txt` | ASCII `-n -m " .#"` | 80x40 | **Hero / README** — tagline "YOU LEAD. AGENTS HUNT!" visible |

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

The canonical render command for the default sigil (braille, maximum visual fidelity):

```
ascii-image-converter <img> -b -d 60,30
```

- `-b` enables braille mode — each char is a 2x4 dot matrix (8x density vs ASCII)
- `-d 60,30` sets explicit width x height in chars; preserves aspect without distortion

Regenerate all variants at once:

```bash
SRC=./assets/new-logo.jpg

# Braille default (terminal must support UTF-8 braille font)
ascii-image-converter "$SRC" -b -d 60,30 > assets/sigil.txt
cp assets/sigil.txt assets/sigil-w60.txt

# ASCII fallbacks for terminals without braille support
ascii-image-converter "$SRC" -W 50 -n -m " .#" > assets/sigil-w50.txt
ascii-image-converter "$SRC" -W 80 -n -m " .#" > assets/sigil-w80.txt

# Verify widths (braille counts bytes but renders 60 cols visually):
for f in assets/sigil*.txt; do
  echo "$f: $(wc -l < $f) lines"
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
