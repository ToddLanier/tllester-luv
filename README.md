# luvtilithurts.co — Static Mirror

This directory contains a scraped static copy of the Gatsby/WordPress site at luvtilithurts.co.
Generated with wget so it can be hosted anywhere (Netlify, GitHub Pages, etc.) without needing
Gatsby, Node, or WordPress.

## How it was scraped

Run this from the parent directory (not inside this folder):

```bash
wget \
  --recursive \
  --level=inf \
  --no-clobber \
  --page-requisites \
  --convert-links \
  --domains=luvtilithurts.co \
  --no-parent \
  --directory-prefix=luvtilithurts-mirror \
  --no-host-directories \
  https://luvtilithurts.co/
```

This downloads all pages, CSS, JS, images, fonts, and SVGs, and rewrites internal links
to work as relative paths (so the site works when opened locally or hosted on a new domain).

## Netlify deployment

The `netlify.toml` in this directory configures a no-build static deployment.
Just point Netlify at this repository and it will serve the files as-is.

No build command. No Node. No Gatsby. No WordPress dependency.

## Site structure

Pages (as of May 2026):

- /                    → index.html
- /about/              → about/index.html
- /symbology/          → symbology/index.html
- /research/           → research/index.html
- /exquisite-corpse/   → exquisite-corpse/index.html
- /contact/            → contact/index.html
- /heart/              → heart/index.html
- /leaf/               → leaf/index.html
- /spaceship/          → spaceship/index.html
- /firefly/            → firefly/index.html
- /hummingbird/        → hummingbird/index.html
- /ankh/               → ankh/index.html

Assets: static/ directory (images, SVGs)

## Note on luvhurts.co

The "Archive" nav link points to luvhurts.co — a separate site. That is NOT included
in this mirror. If you want to preserve it too, run a separate wget against luvhurts.co.
