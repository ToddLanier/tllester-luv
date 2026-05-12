#!/usr/bin/env bash
# fix-images.sh
# Downloads broken images from WP Local and rewrites HTML src attributes.
# Run from inside luvtilithurts-mirror/:
#   bash fix-images.sh

set -euo pipefail

MIRROR="$(cd "$(dirname "$0")" && pwd)"
SWARM_LOCAL="https://swarm.local"
LUVHURTS_LOCAL="https://luvhurts-blog.local"

echo "Mirror: $MIRROR"
echo ""

# ─── Download images from swarm.local ─────────────────────────────────────────
# These were served from swarm.luvtilithurts.co (Gatsby WP backend)

# download_swarm URL_PATH DEST_FILENAME
# URL_PATH: the /uploads/... path with percent-encoding for the curl request
# DEST_FILENAME: the exact filename to save as (use actual Unicode, not percent-encoded)
download_swarm() {
  local url_path="$1"
  local dest_filename="$2"
  local dir
  dir=$(dirname "/uploads/$dest_filename")
  local dest="$MIRROR/wp-content${dir}/${dest_filename##*/}"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ]; then
    echo "  [skip] $dest_filename"
  else
    echo "  [fetch] $SWARM_LOCAL/wp-content$url_path"
    curl -sk --insecure -o "$dest" "$SWARM_LOCAL/wp-content$url_path" && echo "  [ok]" || echo "  [fail]"
  fi
}

# NFD ç used in filenames (c + U+0327 combining cedilla, as macOS/browser expects)
C_CEDILLA=$'\xcc\xa7'
BRUNO_BASE="Bruno-Mendonc${C_CEDILLA}a-e-Felipe-Caprestano-Terra-Falsa-template-1200x1697-1"
BRUNO_URL_BASE="Bruno-Mendon%C3%A7a-e-Felipe-Caprestano-Terra-Falsa-template-1200x1697-1"

echo "=== swarm.local images ==="
download_swarm "/uploads/2020/11/${BRUNO_URL_BASE}-724x1024.jpg"  "2020/11/${BRUNO_BASE}-724x1024.jpg"
download_swarm "/uploads/2020/11/${BRUNO_URL_BASE}-212x300.jpg"   "2020/11/${BRUNO_BASE}-212x300.jpg"
download_swarm "/uploads/2020/11/${BRUNO_URL_BASE}-768x1086.jpg"  "2020/11/${BRUNO_BASE}-768x1086.jpg"
download_swarm "/uploads/2020/11/${BRUNO_URL_BASE}-1086x1536.jpg" "2020/11/${BRUNO_BASE}-1086x1536.jpg"
download_swarm "/uploads/2020/11/${BRUNO_URL_BASE}.jpg"           "2020/11/${BRUNO_BASE}.jpg"

# ─── Download images from luvhurts-blog.local ─────────────────────────────────
# These were served from luvhurts.co

download_luvhurts() {
  local path="$1"
  local dest="$MIRROR/luvhurts-uploads$path"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ]; then
    echo "  [skip] luvhurts-uploads$path"
  else
    echo "  [fetch] $LUVHURTS_LOCAL/wp-content/uploads$path"
    curl -sk --insecure -o "$dest" "$LUVHURTS_LOCAL/wp-content/uploads$path" && echo "  [ok]" || echo "  [fail]"
  fi
}

echo ""
echo "=== luvhurts-blog.local images ==="
download_luvhurts "/2019/05/Brad-Final-01-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-02-1-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-03-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-04-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-05-2-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-06-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-07-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-08-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-09-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-10-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-11-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-12-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-13-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-14-1-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-15-791x1024.jpg"
download_luvhurts "/2019/05/Brad-Final-16-791x1024.jpg"
download_luvhurts "/2019/07/2_gamestorm.png"
download_luvhurts "/2019/07/hack_1.jpg"
download_luvhurts "/2019/09/2_EricRhein_Visitation_FireIsland_2012-812x1024.jpg"
download_luvhurts "/2019/09/EricRhein-Company-Self-Portrait_1999-825x1024.jpg"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.30.28.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.30.36.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.30.44.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.30.50.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.30.57.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.31.04.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.31.14.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.31.22.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-09-at-19.31.30.png"
download_luvhurts "/2019/10/Screen-Shot-2019-10-25-at-19.37.43.png"
download_luvhurts "/2019/12/Felipe-de-Carvalho-Dela%C3%A7%C3%A3o.jpg"
download_luvhurts "/2019/12/Screen-Shot-2019-12-24-at-16.03.16.png"
download_luvhurts "/2020/01/WhatsApp-Image-2020-01-14-at-4.31.20-PM-1024x683.jpeg"
download_luvhurts "/2020/01/WhatsApp-Image-2020-01-14-at-4.31.44-PM-1024x683.jpeg"
download_luvhurts "/2020/02/WhatsApp-Image-2020-02-13-at-5.04.07-PM-1024x768.jpeg"
download_luvhurts "/2020/03/IMG_6669-3-683x1024.jpg"
download_luvhurts "/2020/03/IMG_6734-2-683x1024.jpg"
download_luvhurts "/2020/03/IMG_6763-2-683x1024.jpg"
download_luvhurts "/2020/03/IMG_6804-2-683x1024.jpg"
download_luvhurts "/2020/03/IMG_6818-2-1024x683.jpg"
download_luvhurts "/2020/03/IMG_6826-2-683x1024.jpg"
download_luvhurts "/2020/03/IMG_6899-2-1024x683.jpg"
download_luvhurts "/2020/03/IMG_6931-2-1024x683.jpg"
download_luvhurts "/2020/03/WhatsApp-Image-2018-09-09-at-14.22.07-1-682x1024.jpeg"
download_luvhurts "/2020/03/WhatsApp-Image-2018-09-09-at-14.22.22-1-682x1024.jpeg"
download_luvhurts "/2020/03/WhatsApp-Image-2020-03-31-at-12.39.53-PM-1-768x1024.jpeg"
download_luvhurts "/2020/03/WhatsApp-Image-2020-03-31-at-12.39.53-PM-768x1024.jpeg"
download_luvhurts "/2020/03/WhatsApp-Image-2020-03-31-at-12.39.54-PM-1024x768.jpeg"
download_luvhurts "/2020/03/WhatsApp-Image-2020-03-31-at-12.41.11-PM-1-1024x1024.jpeg"
download_luvhurts "/2020/03/lastrelatory2-1024x683.jpg"

# ─── Rewrite HTML src attributes ──────────────────────────────────────────────

echo ""
echo "=== Rewriting HTML src attributes ==="

find "$MIRROR" -name "*.html" | while read -r htmlfile; do
  # swarm.luvtilithurts.co → local wp-content/
  sed -i '' \
    's|https://swarm\.luvtilithurts\.co/wp-content/|/wp-content/|g' \
    "$htmlfile"

  # luvhurts.co → local luvhurts-uploads/
  sed -i '' \
    's|https://luvhurts\.co/wp-content/uploads/|/luvhurts-uploads/|g' \
    "$htmlfile"

  echo "  [done] ${htmlfile#$MIRROR/}"
done

echo ""
echo "All done. Reload http://localhost:8000 to verify."
echo ""
echo "Downloaded file counts:"
echo "  swarm images:    $(find "$MIRROR/wp-content" -type f 2>/dev/null | wc -l | tr -d ' ')"
echo "  luvhurts images: $(find "$MIRROR/luvhurts-uploads" -type f 2>/dev/null | wc -l | tr -d ' ')"
