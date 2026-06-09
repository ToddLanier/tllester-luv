#!/usr/bin/env python3
"""
seo-mirror.py — post-scrape SEO pass for the luvtilithurts.co static mirror.

The mirror is a wget scrape of a Gatsby site, so its static <head> carries no
canonical, description, or og:url. This script injects them (idempotently) and
regenerates robots.txt + sitemap.xml. Re-run it after every fresh wget scrape
(a scrape overwrites the HTML and wipes these tags).

Usage:  python3 seo-mirror.py
"""
import os
import re

SITE = "https://luv.tllester.info/"
DESC = ("Luv 'til it Hurts — an art project imagining faster resources for "
        "HIV-related activism. Archived mirror of luvtilithurts.co.")
MARK = "<!-- seo-mirror -->"  # idempotency marker

root = os.path.dirname(os.path.abspath(__file__))
urls = []

for dirpath, dirnames, filenames in os.walk(root):
    if "/.git" in dirpath or dirpath.endswith("/.git"):
        continue
    dirnames[:] = [d for d in dirnames if d != ".git"]
    for fn in filenames:
        if fn != "index.html":
            continue
        fpath = os.path.join(dirpath, fn)
        rel = os.path.relpath(fpath, root)
        # dir/index.html -> /dir/ ; index.html -> /
        url_path = "" if rel == "index.html" else rel[:-len("index.html")]
        url = SITE + url_path.replace(os.sep, "/")
        urls.append(url)

        html = open(fpath, encoding="utf-8").read()
        if MARK in html:  # already injected — refresh by stripping old block first
            html = re.sub(r"\n?\s*" + re.escape(MARK) + r".*?" + re.escape(MARK),
                          "", html, flags=re.S)
        block = (f"{MARK}"
                 f'<link rel="canonical" href="{url}"/>'
                 f'<meta property="og:url" content="{url}"/>'
                 f'<meta property="og:type" content="website"/>'
                 f'<meta name="description" content="{DESC}"/>'
                 f'<meta name="robots" content="index, follow"/>'
                 f"{MARK}")
        if "</head>" in html:
            html = html.replace("</head>", block + "</head>", 1)
            open(fpath, "w", encoding="utf-8").write(html)

urls.sort(key=lambda u: (u != SITE, u))  # home first

# sitemap.xml
sm = ['<?xml version="1.0" encoding="UTF-8"?>',
      '<urlset xmlns="http://www.sitemap.org/schemas/sitemap/0.9">'.replace("sitemap.org", "sitemaps.org")]
for u in urls:
    sm.append(f"  <url><loc>{u}</loc><changefreq>yearly</changefreq></url>")
sm.append("</urlset>\n")
open(os.path.join(root, "sitemap.xml"), "w", encoding="utf-8").write("\n".join(sm))

# robots.txt
open(os.path.join(root, "robots.txt"), "w", encoding="utf-8").write(
    "User-agent: *\nAllow: /\n\nSitemap: " + SITE + "sitemap.xml\n")

print(f"Injected SEO head tags into {len(urls)} pages.")
print(f"Wrote sitemap.xml ({len(urls)} urls) and robots.txt.")
