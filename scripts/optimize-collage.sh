#!/bin/bash
# Optimize raw photos into 300x300 square JPEG cards for the hero collage.
# Usage: bash scripts/optimize-collage.sh
# Add/remove photos in assets-original/raw_pics/ and re-run to regenerate.

SRC="assets-original/raw_pics"
DEST="assets/collage"
SIZE=300
QUALITY=70

# Clean and recreate output directory
rm -rf "$DEST"
mkdir -p "$DEST"

i=1
for f in "$SRC"/*; do
  # Skip non-image files
  case "${f##*.}" in
    jpg|jpeg|JPG|JPEG|png|PNG|heic|HEIC) ;;
    *) continue ;;
  esac

  idx=$(printf "%02d" $i)

  # Get dimensions
  w=$(sips --getProperty pixelWidth "$f" 2>/dev/null | tail -1 | awk '{print $2}')
  h=$(sips --getProperty pixelHeight "$f" 2>/dev/null | tail -1 | awk '{print $2}')

  if [ -z "$w" ] || [ -z "$h" ]; then
    echo "SKIP (unreadable): $f"
    continue
  fi

  # Resize so the short side = 300, then crop to square
  # Landscape: center-crop horizontally
  # Portrait: crop from top to keep heads in frame
  if [ "$w" -gt "$h" ]; then
    sips --resampleHeight $SIZE -s formatOptions $QUALITY -s format jpeg "$f" --out "$DEST/${idx}.jpg" 2>/dev/null
    new_w=$(sips --getProperty pixelWidth "$DEST/${idx}.jpg" 2>/dev/null | tail -1 | awk '{print $2}')
    offset=$(( (new_w - SIZE) / 2 ))
    sips --cropToHeightWidth $SIZE $SIZE --cropOffset 0 $offset "$DEST/${idx}.jpg" 2>/dev/null
  else
    sips --resampleWidth $SIZE -s formatOptions $QUALITY -s format jpeg "$f" --out "$DEST/${idx}.jpg" 2>/dev/null
    sips --cropToHeightWidth $SIZE $SIZE --cropOffset 0 0 "$DEST/${idx}.jpg" 2>/dev/null
  fi

  # Guarantee exact 300x300
  sips --resampleHeightWidth $SIZE $SIZE "$DEST/${idx}.jpg" 2>/dev/null > /dev/null

  echo "OK: $(basename "$f") -> ${idx}.jpg"
  i=$((i + 1))
done

count=$((i - 1))
echo "$count" > "$DEST/count.txt"
echo "--- Done: $count images in $DEST/ ---"
