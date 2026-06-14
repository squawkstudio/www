# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A plain static website for Squawk Studio, LLC, served via GitHub Pages at `www.squawkstudio.com` (set by `CNAME`). It is a landing page that links out to the company's products. There is **no build step, no test suite, and no dependencies** — `package.json` is an empty stub. `.nojekyll` disables Jekyll so files are served as-is.

## Deployment

The `gh-pages` branch *is* production. A plain `git push` to `gh-pages` publishes the site immediately — there is no CI or build. Preview locally by opening `index.html` directly or with any static server (e.g. `python3 -m http.server`).

## Critical: the `timerz/` subfolder is foreign

`timerz/` is a compiled build (Create React App output: hashed `static/js`, `static/css`, `asset-manifest.json`) that is **published into this repo by a separate, private repository**. Do not hand-edit, regenerate, or delete its contents — a careless push from this repo can wipe what the other repo deployed. Treat it as read-only here. The same caution applies to any future subfolder owned by another repo (this repo must stay public for Pages; subfolder repos can be private).

## Page structure

The site is hand-written HTML/CSS/JS — edit the source files directly, there is nothing to compile:

- `index.html` — the landing page. The `.apps` grid is a list of `<a><img></a>` tiles linking to external products (familymap.ai, shiftfabric.com, bizallie.com, the local `timerz/` app, etc.). To add/change/reorder a product, edit this grid and add its logo under `images/`.
- `video.js` — `onVideoClick(link)` / `onPopClick()` drive a fullscreen modal that plays the logo video (`images/squawk-diamond.mp4`) when the logo is clicked.
- `styles.css` — all styling, including `#video_pop` (the modal overlay) and `.appImage` (the product tiles).
- Root also holds favicons / PWA manifest assets (`site.webmanifest`, `browserconfig.xml`, `*.png`, `favicon.ico`) referenced from `index.html`.

## Social share image

`images/og-banner.png` (the 1200×630 card referenced by the `og:image`/`twitter:image` tags) is **generated, not hand-edited**. Regenerate it with `scripts/make-banner.sh` (needs ImageMagick 7 and macOS system Arial fonts) after changing the wording, colors, or logo, then commit the resulting PNG. Don't edit the PNG directly — your changes would be lost on the next run.
