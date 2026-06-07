# AGENTS.md — Jeffrey Bergier's Personal Site

## Overview

This is a [Jekyll](https://jekyllrb.com/) 4.4 static site powering
[jeffburg.com](https://jeffburg.com). The `source/` directory is the Jekyll
root. The site is deployed to GitHub Pages via the CI workflow on every push
to `main`.

## How to Run Locally

### Prerequisites

- Ruby 3.3+
- Bundler

### Quick Start

```bash
cd source                    # Jekyll root is ./source, NOT the repo root
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

The site will be available at `http://localhost:8080`.

### Docker Alternative

```bash
docker build -t ruby-container .
docker-compose up -d
docker exec -it jekyll-environment bash
# Inside container:
cd /source
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

## How to Build

```bash
cd source
bundle exec jekyll build
```

Output goes to `source/_site/`. This is what CI deploys.

## Theme

The site uses the [Minima](https://github.com/jekyll/minima) theme (dark skin),
pinned to a specific Git ref (`c27c54a`) in the Gemfile:

```ruby
gem "minima", github: "jekyll/minima", ref: "c27c54a"
```

The theme's `_includes`, `_layouts`, and `_sass` files live inside the minima
gem. You won't find theme files in the repo — only overrides.

### Skin Configuration (`source/_config.yml`)

```yaml
minima:
  skin: dark
  show_excerpts: true
```

## Theme Customizations

### Custom CSS (`source/assets/css/style.scss`)

The main stylesheet imports the Minima theme, then adds overrides:

```scss
@import "minima/skins/{{ site.minima.skin | default: 'classic' }}", "minima/initialize";
@import "icons";
```

Key customizations:

| Feature | Description |
|---|---|
| **Font** | System font stack (`-apple-system, BlinkMacSystemFont, "Helvetica Neue", Helvetica, Arial, sans-serif`) |
| **Link color** | White (`#FFF`) with underline; darkens on hover |
| **Body text** | `#CFCFCF` on dark background |
| **`.thumbnail`** | Floats images left, max 300px. Goes full-width below 800px |
| **`.reflect`** | CSS `-webkit-box-reflect` for a reflection effect below images |
| **`.below-{xl,lg,md,sm,xs}`** | Controls reflection distance |
| **`.round-{none,sm,md,lg}`** | Controls border-radius of reflected elements |
| **`.continued`** | Suppresses the automatic clearfix after paragraphs/lists (for flowing text around floated images) |
| **`.prompt-{info,warning,error}`** | Styled callout boxes with Font Awesome icon prefixes |
| **`.accessory-layout`** | Two-column flex layout: `.al-accessory` (30%) + `.al-primary` (65%); stacks vertically below 800px |
| **`.title-accessory`** | Centered header image area, max 256px |
| **Site header** | No top border, no underline on nav links |

### Icon System (`source/assets/css/_icons.scss`)

A massive auto-generated CSS file (~9850 lines) that provides icon classes
using CSS background-images. All icons are extracted from vintage Apple `.icns`
files.

**Naming convention:** `{prefix}-{name}-{size}`

- **Apple app icons:** `apl-app-*` (e.g. `apl-app-xcode-256`, `apl-app-finder-128`)
- **Apple computer icons:** `apl-computer-*` (e.g. `apl-computer-imac-g4-17-256`)
- **Apple device icons:** `apl-device-*` (e.g. `apl-device-iphone-5-black-256`)
- **Apple folder/document/drive icons:** `apl-folder-*`, `apl-doc-*`, `apl-drive-*`
- **Apple toolbar icons:** `apl-toolbar-*`
- **Apple preference icons:** `apl-pref-*`
- **Apple developer icons:** `apl-dev-*`
- **Jeff's app icons:** `jsb-app-*` (e.g. `jsb-app-teskemon-256`, `jsb-app-hipstapaper-256`)

**Sizes:** `8`, `16`, `24`, `32`, `64`, `128`, `256`, `512` (pixels)

**Usage in Markdown:**

```html
<i class='apl-app-xcode-256 reflect below-sm round-none'></i>
```

**Generating icons:** The `scripts/` directory contains a pipeline:

1. `icns0_EZtoStart.sh` — Orchestrator
2. `icns1_FINDtoICNS.sh` — Locates `.icns` files
3. `icns2_ICNStoPNG.sh` — Extracts PNGs from `.icns`
4. `icns3_PNGtoCSS.sh` — Generates `_icons.scss` from PNGs
5. `icns4_CSStoMD.sh` — Generates `unlisted/icons.md` reference table

### Layout Overrides

The repo overrides **four layouts** in `source/_layouts/`:

| Layout | Used For |
|---|---|
| `home-category.html` | Category landing pages (Apps, Design, Retro-Tech). Shows category title + list of posts filtered by `page.category` |
| `post.html` | Standard blog posts. Shows title with optional `titleAccessory`, date, author |
| `post-accessory.html` | Blog posts with a sidebar. Uses `page.accessory` for sidebar content in the `.accessory-layout` |
| `page.html` | Generic pages like 404. Simple title + content |

Key front matter variables these layouts consume:
- **`titleAccessory`** — HTML/markdown rendered above the post title (usually an `<i>` icon tag)
- **`accessory`** — HTML/markdown rendered in the left sidebar column (only for `post-accessory` layout)
- **`excerpt`** — Shown below the title in post header
- **`exclude`** — If `true`, page is excluded from nav (used by `404.html` and `unlisted/icons.md`)

### Navigation Include (`source/_includes/nav-items.html`)

Builds nav links from `include.paths`. Called by Minima's header (not included
in this repo — it's in the theme gem). The owner has modified the theme's
header to call this include.

## Blog Post Structure

Posts live in `source/_posts/` with the Jekyll naming convention:
`YYYY-MM-DD-slug.md`

### Front Matter Template (Standard Post)

```yaml
---
layout: post
title: "Post Title"
titleAccessory: "<i class='apl-app-xcode-256 reflect below-md round-none'></i>"
excerpt: "A short description shown below the title."
categories: [Retro-Tech]   # One of: Apps, Design, Retro-Tech
tags: [Apps, PowerPC, iOS, Hobby]
---
```

### Front Matter Template (Post with Sidebar)

```yaml
---
layout: post-accessory
title: "Post Title"
titleAccessory: "![Icon](/path/to/icon.png){: .reflect .below-xl }"
excerpt: "A short description."
categories: [Apps]
tags: [Apps, Hobby]
accessory: |
  [![Screenshot 1](/path/to/01-thumb.png)](/path/to/01-full.png)
  [![Screenshot 2](/path/to/02-thumb.png)](/path/to/02-full.png)
---
```

### Post Content Conventions

- **Table of Contents:** Every post includes:
  ```markdown
  ## Table of Contents
  * TOC
  {:toc}
  ```

- **Images:**
  - Use `-thumb` / `-full` naming for app screenshots
  - Use `-600` / `-2k` naming for design portfolio images
  - Thumbnails link to full images: `[![alt](thumb.png)](full.png)`
  - App screenshots often displayed in a 5-column table row
  - Use `{: .thumbnail}` on images that should float left
  - Use `{: .reflect .below-xl .round-sm}` for reflection effects on icons

- **Links:**
  - Download links use Font Awesome icons: `<i class="fa-brands fa-github"></i>`
  - External links use `{: target="_blank" }`

- **Code blocks:** Used for terminal commands, bash scripts, code snippets

- **Tables:** Used for side-by-side screenshots and comparison layouts

## Categories

Three main categories, each with a landing page:

| Category | Permalink | Template | Icon |
|---|---|---|---|
| **Apps** | `/apps/` | `apps.md` | `fa-solid fa-compass-drafting` |
| **Design** | `/design/` | `design.md` | `fa-solid fa-swatchbook` |
| **Retro-Tech** | `/retro-tech/` | `retro-tech.md` | `fa-solid fa-microchip` |

Category pages use the `home-category` layout with a `category` front matter
field that matches tags in posts. Each landing page has a `titleAccessory` with
a decorative Mac OS X-style icon.

## Writing Tone & Style

- **First-person, conversational, and personal.** The author writes as himself
  ("I figured out…", "I built this for myself…", "I would not consider myself
  the best developer…")
- **Humble but confident.** Acknowledges limitations ("its not the greatest
  Swift code") but clearly knows his subject matter deeply.
- **Technical depth.** Goes into architecture, API choices, and implementation
  details. Assumes the reader is technically literate but not necessarily an
  expert in the specific domain.
- **Apple-ecosystem native.** Deep knowledge of iOS, macOS, Xcode, AppKit, UIKit,
  Swift, Objective-C. Uses Apple terminology naturally.
- **Nostalgic but pragmatic.** Passionate about retro computing (PowerPC Macs,
  old iOS versions) but always focused on what's actually achievable.
- **Light emoji use.** Mostly Font Awesome icons for visual flair. Occasional
  emoji: ✌️ (`fa-hand-peace`), ☠️ (`fa-skull-crossbones`).
- **Self-deprecating humor.** "I am not sure how easy it will be to compile…"
  "ask how I know"
- **Links to source code, Mastodon, and external resources** are woven
  naturally into the narrative.

## Custom Styles Used in Posts

| Kramdown Attribute | Effect |
|---|---|
| `{: .thumbnail }` | Floats image left, max 300px |
| `{: .reflect }` | Adds CSS reflection below the image |
| `{: .below-xl }`, `{: .below-lg }`, `{: .below-md }`, `{: .below-sm }`, `{: .below-xs }` | Controls reflection distance |
| `{: .round-none }`, `{: .round-sm }`, `{: .round-md }`, `{: .round-lg }` | Controls border-radius |
| `{: .continued }` | Suppresses clearfix to keep text flowing around floated images |
| `{: target="_blank" }` | Opens link in new tab |
| `{::options toc_levels="1,2,3" /}` | Controls TOC depth |

## CI/CD

GitHub Actions (`.github/workflows/gh-pages.yml`):
- Triggers on push to `main`
- Sets up Ruby 3.3, runs `bundle install` in `./source`, runs `bundle exec jekyll build`
- Deploys `source/_site/` to GitHub Pages via `peaceiris/actions-gh-pages@v4`

## File Layout Reference

```
.
├── Dockerfile                    # Debian + Ruby + Jekyll
├── docker-compose.yml            # Mounts ./source into /source
├── README.md                     # (Somewhat outdated) setup instructions
├── scripts/                      # Icon pipeline scripts (icns0–4)
├── .github/workflows/gh-pages.yml
└── source/                       # ← Jekyll root
    ├── _config.yml               # Jekyll config, Minima dark skin
    ├── Gemfile                   # jekyll ~> 4.4.1, minima (git ref)
    ├── Gemfile.lock
    ├── index.md                  # Homepage
    ├── apps.md                   # Apps category landing page
    ├── design.md                 # Design category landing page
    ├── retro-tech.md             # Retro-Tech category landing page
    ├── 404.html
    ├── CNAME                     # Contains: jeffburg.com
    ├── _data/
    │   └── constants.yml         # Nav link data (title+url per category)
    ├── _drafts/
    │   └── IconSystem.md         # Draft post
    ├── _includes/
    │   └── nav-items.html        # Custom nav include
    ├── _layouts/
    │   ├── home-category.html    # Category landing layout
    │   ├── page.html             # Generic page layout
    │   ├── post.html             # Blog post layout
    │   └── post-accessory.html   # Blog post with sidebar layout
    ├── _posts/                   # Blog posts (YYYY-MM-DD-slug.md)
    ├── assets/
    │   ├── css/
    │   │   ├── style.scss        # Theme overrides + icons import
    │   │   └── _icons.scss       # Auto-generated icon CSS (~9850 lines)
    │   ├── icons/                # .iconset dirs with PNGs for each icon
    │   └── images/               # Post images, organized by topic
    └── unlisted/
        └── icons.md              # Reference table of all available icons
```

## Important Notes for Agents

1. **The Jekyll root is `source/`, not the repo root.** All `jekyll` commands
   must run from `source/`.

2. **Do not edit `_icons.scss` directly.** It is auto-generated by the scripts
   pipeline. If you need to add icons, use the scripts.

3. **The `_drafts/` folder** contains unpublished posts. These won't appear on
   the live site.

4. **The `unlisted/` folder** contains pages excluded from navigation
   (`exclude: true` in front matter).

5. **Image conventions matter.** When adding images for blog posts, follow the
   `-thumb`/`-full` or `-600`/`-2k` pattern. Thumbnails should be ~300px wide.

6. **TOC is expected on every post.** Posts without `* TOC {:toc}` will look
   inconsistent.

7. **The Minima theme is pinned to a specific Git ref.** Upgrading the theme
   may break customizations that depend on specific theme internals.

8. **The home page** (`index.md`) uses the `home` layout (from Minima), which
   auto-lists recent posts. The front matter sections ("Ongoing Projects",
   "About Me") are static Markdown content.

9. **No tests.** This is a static site with no test suite.

10. **Font Awesome 7** is included (via the theme or a CDN — not in this repo).
    Icons use `fa-solid`, `fa-brands`, `fa-regular` prefixes.
