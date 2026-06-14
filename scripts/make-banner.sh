#!/bin/bash
#
# Regenerates the social-share card at images/og-banner.png (1200x630),
# which is referenced by the og:image / twitter:image tags in index.html.
#
# Requirements: ImageMagick 7 (`magick`) and the macOS system Arial fonts.
# Usage: scripts/make-banner.sh   (run from anywhere; paths are resolved
# relative to the repo root).
#
set -euo pipefail
unset CDPATH  # otherwise cd echoes its target and corrupts the captures below

# Resolve repo root as the parent of this script's directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)"
cd "$ROOT"

ARIAL_BOLD="/System/Library/Fonts/Supplemental/Arial Bold.ttf"
ARIAL="/System/Library/Fonts/Supplemental/Arial.ttf"
ORANGE="#F58220"   # toucan beak / brand accent
DARK="#2b2b2b"     # headline
GREY="#5f5f5f"     # tagline

for f in "$ARIAL_BOLD" "$ARIAL"; do
  [ -f "$f" ] || { echo "Missing font: $f (this script expects macOS system fonts)" >&2; exit 1; }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Trim transparent padding off the toucan so it sits flush against the edge.
magick images/squawky.png -trim +repage -resize x520 "$TMP/squawky_trim.png"

# CTA pill (408x70) with text composited dead-center — no baseline guesswork.
magick -size 408x70 xc:none -fill "$ORANGE" -draw "roundrectangle 0,0 407,69 35,35" "$TMP/pill.png"
magick -background none -fill white -font "$ARIAL_BOLD" -pointsize 31 label:"squawkstudio.com  →" "$TMP/ctatext.png"
magick "$TMP/pill.png" "$TMP/ctatext.png" -gravity center -composite "$TMP/cta.png"

# 1200x630 card: light background, orange accent bar, logo left, text + CTA right.
magick -size 1200x630 xc:white \
  -fill "$ORANGE" -draw "rectangle 0,622 1200,630" \
  \( "$TMP/squawky_trim.png" \) -gravity West -geometry +55+0 -composite \
  -gravity NorthWest \
  -font "$ARIAL_BOLD" -fill "$DARK" -pointsize 92 -annotate +590+195 "Squawk" \
  -font "$ARIAL_BOLD" -fill "$DARK" -pointsize 92 -annotate +590+307 "Studio" \
  -font "$ARIAL"      -fill "$GREY" -pointsize 36 -annotate +594+387 "Innovative software & apps" \
  \( "$TMP/cta.png" \) -gravity NorthWest -geometry +590+432 -composite \
  -strip -depth 8 \
  images/og-banner.png

magick identify images/og-banner.png
