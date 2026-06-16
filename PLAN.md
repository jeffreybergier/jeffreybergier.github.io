# Old Blog Migration Plan

This plan captures how to migrate remaining content from the old static site at
`/repo/checkouts/www-jeffburg-com` into this Jekyll site without rewriting the
articles.

## Primary Goal

Migrate the old blog/project pages into the new blog style while preserving the
original text.

Do not modernize the prose, fix old wording, rewrite descriptions, or change the
voice. Treat this as a content-preserving port from the old light-mode Bootstrap
site into the new dark-mode Jekyll site.

## Source And Destination

- Old source repo: `/repo/checkouts/www-jeffburg-com`
- Old article root: `/repo/checkouts/www-jeffburg-com/web-root`
- New destination repo: `/repo/checkouts/jeffreybergier.github.io`
- New Jekyll root: `/repo/checkouts/jeffreybergier.github.io/source`
- New posts directory: `source/_posts`
- New image root: `source/assets/images`
- New download root: `source/assets/downloads`

## Migration Checklist

These old pages appear to be real project/article content. Check them off as
they are migrated into new Jekyll posts.

| Status | Old content | Old file | Suggested category | Notes |
| --- | --- | --- | --- | --- |
| [x] | Change Management Rapid Prototype | `web-root/changes.html` | Design | Migrated to `source/_posts/2016-01-01-Change-Management.md` |
| [x] | Rule Icon System | `web-root/iconsys.html` | Design | Migrated to `source/_posts/2016-01-01-Rule-Icon-System.md` |
| [x] | SteelReserve Design | `web-root/srdesign.html` | Design | Migrated to `source/_posts/2015-01-01-SteelReserve-Design.md` |
| [ ] | Topology Eyewear | section in `web-root/cocoa.html` | Design or Apps | Only exists as a section inside the old Cocoa landing page |
| [x] | WeatherMe | `web-root/weather.html` | Design | Migrated to `source/_posts/2011-01-01-WeatherMe.md` |
| [x] | Design for Manufacture | `web-root/penpot.html` | Design | Migrated to `source/_posts/2010-01-01-Design-for-Manufacture.md` |
| [x] | Innovative Kitchenware / Intelligent Kitchen | `web-root/ikb.html` | Design | Migrated to `source/_posts/2010-01-01-Innovative-Kitchenware.md`; old hub says "Intelligent Kitchen"; detail page says "Innovative Kitchenware" |
| [x] | Architectural Lighting | `web-root/lighting.html` | Design | Migrated to `source/_posts/2009-01-01-Architectural-Lighting.md` |
| [x] | Electronics | `web-root/electronics.html` | Design | Migrated to `source/_posts/2010-01-01-Electronics.md` |
| [x] | Surface Modeling | `web-root/surface.html` | Design | Migrated to `source/_posts/2010-01-01-Surface-Modeling.md` |
| [x] | Workshop Experience | `web-root/workshop.html` | Design | Migrated to `source/_posts/2010-01-01-Workshop-Experience.md` |
| [x] | `[REDACTED] Project` | `web-root/redacted.html` | Design | Migrated to `source/_posts/2009-01-01-Redacted-Project.md` |

Category decision: migrate Innovative Kitchenware, Architectural Lighting,
Electronics, Surface Modeling, Workshop Experience, and `[REDACTED] Project`
under `categories: [Design]` if/when they are ported.

These old items already have new posts and should not be duplicated:

- QoS Redesign
- WaterMe
- Gratuity
- Hipstapaper

Ignore old shell/navigation pages as articles:

- `web-root/index.html`
- `web-root/resume.html`
- `web-root/cocoa.html`, except for the Topology Eyewear section
- `web-root/ux.html`
- `web-root/productdesign.html`

## Post Structure

Create one Markdown post per old article in `source/_posts` using the existing
new-site conventions.

Use the original project year when choosing the post date if no better date is
available. A conservative pattern is `YYYY-01-01-slug.md`, matching existing
older migrated posts like `2014-01-01-QoS.md`.

Typical front matter:

```yaml
---
layout: post
title: "Original Title"
titleAccessory: "[![Project Image](/assets/images/design/project-slug/image-600.png)](/assets/images/design/project-slug/image-2k.png){: .reflect .below-xl .round-sm }"
excerpt: "Original short intro text"
categories: [Design]
tags: [Design, Professional]
---
```

Use `layout: post-accessory` only when the article benefits from the existing
two-column accessory gallery pattern used by app posts. Most old design pages
should use `layout: post`, like the migrated QoS post.

## Text Migration Rules

- Extract only the article body from the old HTML.
- Preserve the original headings, paragraphs, dates, links, and image order.
- Do not rewrite prose.
- Do not fix old typos unless explicitly asked.
- Do not bring over Bootstrap rows, columns, jumbotrons, nav, footer, glyphicons,
  button classes, or old layout wrappers.
- Convert structural HTML to Markdown where practical.
- Keep HTML only when it is simpler or needed for tables/media.
- Preserve external links and downloadable document links.

## Image And Asset Rules

Move each article's assets into a new project-specific folder.

Suggested examples:

```text
source/assets/images/design/change-management/
source/assets/images/design/rule-icon-system/
source/assets/images/design/steelreserve-design/
source/assets/images/design/weatherme/
source/assets/downloads/design/weatherme/
```

Preserve old small/large image pairs:

- Old `*-600` image becomes the visible inline image.
- Old `*-2k` image becomes the linked full-size image.
- Old `*-300` image becomes the visible inline image.
- Old `*-1k` image becomes the linked full-size image.

Use the new linked-thumbnail pattern:

```markdown
[![Screenshot](/assets/images/design/change-management/visual-600.png)](/assets/images/design/change-management/visual-2k.png){: .thumbnail }
```

Do not upscale images just to force a naming convention. If only one useful
image size exists, use it for both the displayed image and the link.

## Dark Mode Image Handling

The old site had a white background. The new site has a black/dark background.
Several old PNGs have transparency and depend on the old white page background
to look correct.

A migration agent must check every old PNG for alpha/transparency before using
it in the new site.

For UI mockups, diagrams, process boards, screenshots, and student design boards:

- Flatten transparent PNGs onto white or a very light neutral background.
- Generate thumbnails from the corrected full-size image.
- Preserve the image content and text exactly.
- Do not invert, recolor, redesign, or crop aggressively.

For photos and opaque JPEGs:

- Keep them as-is unless a thumbnail needs to be generated.

For app icons or logo-like artwork:

- Keep transparency only if the image is intended to float on dark mode.
- Otherwise flatten to white/light neutral like the original old-site context.

Useful ImageMagick command:

```bash
magick old.png -background white -alpha remove -alpha off new.png
```

Useful transparency check:

```bash
identify -format '%f\t%m\t%wx%h\t%[channels]\t%[opaque]\n' path/to/images/*
```

Known old transparent PNG groups that likely need white matting:

- `web-root/changesassets/*`
- `web-root/iconsysassets/*`
- `web-root/srdesignassets/*`
- Some `web-root/pdassets/penpot-*.png`
- `web-root/pdassets/weather-06-1k.png`
- `web-root/pdassets/weather-development-1k.png`
- `web-root/pdassets/weather-execution-1k.png`
- `web-root/pdassets/weather-future-1k.png`
- `web-root/pdassets/weather-research-1k.png`
- `web-root/pdassets/workshop-tb1-300.png`

## Style Target

Use the existing migrated QoS post as the model for old design work:

- Representative image in `titleAccessory`
- Original intro text in `excerpt`
- Main content in Markdown
- Body screenshots as linked thumbnails with `.thumbnail`
- Table of contents only if it improves navigation for a long post
- No attempt to recreate the old Bootstrap layout

Use existing app posts such as WaterMe, Gratuity, and Hipstapaper as the model
only for app-style posts that need an accessory gallery.

## Verification

After migration work, run the Jekyll build from the new site's source directory:

```bash
cd /repo/checkouts/jeffreybergier.github.io/source
bundle exec jekyll build
```

There are no automated tests. For meaningful verification, also serve the site
and visually inspect the migrated pages on the dark background:

```bash
cd /repo/checkouts/jeffreybergier.github.io/source
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

Check especially:

- Transparent old images do not disappear into the dark page background.
- Text inside screenshots and diagrams remains readable.
- Thumbnail links open the full-size images.
- PDF/download links work.
- Category pages list the migrated posts.
- No old Bootstrap styling leaks into the new post body.

## Repository Rules

- Never commit migration changes unless explicitly asked.
- Never push changes.
- Keep edits scoped to migrated posts and their assets.
- Do not modify unrelated existing posts while migrating old content.
