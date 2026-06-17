# AGENTS.md

## Project Overview

This is Jeffrey Bergier's personal website and blog, a [Jekyll](https://jekyllrb.com/) static site hosted on GitHub Pages at [jeffburg.com](https://jeffburg.com). The Jekyll source lives entirely in the `source/` directory.

- **Ruby version**: CI uses Ruby 3.3; the Altivec Compose workflow uses Ruby 3.0-compatible locked gems
- **Jekyll version**: `~> 4.4.1`
- **Bundler version**: 2.5.23 (as recorded in `Gemfile.lock`)
- **Theme**: [minima](https://github.com/jekyll/minima) (pinned to commit `c27c54a`)
- **Skin**: dark
- **CI/CD**: GitHub Actions (`.github/workflows/gh-pages.yml`) builds and deploys on push to `main`

## How to Run the Site Locally

### Option 1: Docker (recommended for consistency)

```bash
docker compose up serve
```

Then open `http://localhost:8080`.

For an interactive Altivec shell:

```bash
docker compose run --rm altivec-intelligence
```

### Required Altivec/Bundler Environment

The Compose `serve` service sets Bundler paths and a specific `PATH` ordering.
Use the same environment when running `bundle install`, `bundle exec jekyll
build`, or `bundle exec jekyll serve` manually inside Codex/Altivec:

```bash
export BUNDLE_APP_CONFIG=/root/.bundle/jeffreybergier.github.io/config
export BUNDLE_PATH=/root/.bundle/jeffreybergier.github.io
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/altivec/bin:/osxcross/target/bin
```

This ordering is important. `/osxcross/target/bin` contains a macOS linker named
`ld`; if it appears before `/usr/bin`, native Ruby gems can fail to compile with
errors such as `ld: unknown option: -plugin`.

### Option 2: Local Ruby

```bash
cd source
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

The site auto-regenerates on file changes. The generated output goes to `source/_site/` (git-ignored).

## How to Build (CI equivalent)

```bash
cd source
bundle install
bundle exec jekyll build
```

## How to Test

There are no automated tests. To verify changes:

1. Run `bundle exec jekyll build` — ensure no build errors. Inside Altivec/Codex,
   set the required Bundler environment above first.
2. Run `bundle exec jekyll serve` and manually inspect pages in a browser.
3. Check that all layout variants render correctly: home page, category pages (`/apps/`, `/design/`, `/retro-tech/`, `/unenshittification/`), individual posts (standard, accessory, and with title accessories), and the 404 page.

## Theme: Minima with Heavy Customization

### Base Theme

The site uses the **minima** theme (dark skin) from `jekyll/minima` on GitHub, pinned to a specific commit. The dark skin provides a dark background with light text.

### Custom Layouts (all in `source/_layouts/`)

Four custom layouts override/extend minima's default `base` layout:

| Layout | File | Purpose |
|--------|------|---------|
| `page` | `page.html` | Generic content page. Supports `titleAccessory` front matter. |
| `post` | `post.html` | Standard blog post with date, author, and `titleAccessory`. Uses `layout: base` directly. |
| `post-accessory` | `post-accessory.html` | Post with a two-column "accessory" layout — a sidebar (`al-accessory`) next to the main content (`al-primary`). The sidebar content comes from the `accessory` front matter field (rendered as markdown). |
| `home-category` | `home-category.html` | Category index pages (`/apps/`, `/design/`, `/retro-tech/`). Lists all posts in a given `category` with dates and excerpts. Supports `titleAccessory` and `excerpt`. Shows "Coming Soon" if no posts exist. |

### Custom Includes

- **`source/_includes/nav-items.html`**: Generates the navigation bar by iterating over page paths. Uses the page `title` directly (unescaped) to allow HTML like Font Awesome icons in nav labels. The nav is populated from the pages defined in `_data/constants.yml`.

### Custom Sass/CSS (in `source/assets/css/`)

- **`style.scss`**: The main override file. Imports minima's dark skin, then adds:
  - Apple system font stack (`-apple-system, BlinkMacSystemFont, …`)
  - Light grey body text (`#CFCFCF`), white links with underline
  - Removes header top border and link underlines in the header
  - **Thumbnail images**: `.thumbnail` floats images left (max 300px), goes full-width on narrow screens (≤800px)
  - **Accessory layout**: Two-column flex layout (30%/65%) that stacks vertically on mobile
  - **Title accessory**: Centers a decorative element above the title (max 256px)
  - **Prompt callouts**: `.prompt-info`, `.prompt-warning`, `.prompt-error` — colored boxes with Font Awesome icons and colored left borders
  - **Reflection utilities**: `.reflect` applies `-webkit-box-reflect` for a mirror/reflection effect. Modifier classes control distance (`.below-xl` through `.below-xs`) and corner radius (`.round-none` through `.round-lg`)
  - **`.continued`**: Removes the clearfix on floated content so text continues to wrap around thumbnails

- **`_icons.scss`**: Auto-generated CSS classes for inline icon rendering. Each icon has classes at multiple sizes (`-8`, `-16`, `-32`, `-64`, `-128`, `-256`). Icons are rendered as `inline-block` elements with `background-image` pointing to PNG files. Two namespaces: `apl-*` (Apple system icons) and `jsb-*` (Jeff's custom app icons).

### Font Awesome

The site uses **Font Awesome 7 Free** for UI icons. Available classes include `fas fa-*` (solid), `fab fa-*` (brands), and `far fa-*` (regular). These are used in navigation labels, in-line in post body text, and in the prompt callout CSS `::before` pseudo-elements.

### Social Links

Configured in `_config.yml` under `minima.social_links`: GitHub, Mastodon, and LinkedIn. The home page renders these as a `<ul>` list with Font Awesome brand icons.

## Data Files

- **`source/_data/constants.yml`**: Defines the content categories with Font Awesome icon markup, titles, and URLs.

## Blog Post Structure

### File Naming

Posts live in `source/_posts/` with the format `YYYY-MM-DD-slug.md`.

### Front Matter

All posts use this front matter:

```yaml
---
layout: post          # or post-accessory
title: "Post Title"
titleAccessory: ""    # Optional: HTML/markdown shown above the title (usually an icon or image)
excerpt: ""           # Optional: shown in the header and on category index pages
categories: [Apps]    # Must match one of the category tags listed below
tags: [tag1, tag2]    # Free-form tags
author: Jeffrey Bergier # Auto-populated by the post layout
---
```

The `post-accessory` layout adds an `accessory` field:

```yaml
accessory: |
  [![screenshot thumb](thumb.png)](full.png)
  [![screenshot thumb](thumb2.png)](full2.png)
```

### Kramdown Markdown Features

Posts use [Kramdown](https://kramdown.gettalong.org/) with these conventions:

- **Table of Contents**: `* TOC {:toc}` generates an auto-TOC. Some posts use `{::options toc_levels="1,2,3" /}` to control depth.
- **Inline attribute lists**: `{: .classname}` applies CSS classes to preceding elements
- **HTML**: Inline HTML is used extensively for icons, tables, and complex layouts

## Custom Post Styles and Conventions

### Images: Thumbnail → Full Pattern

Every image uses a *thumb + full* pattern. The thumbnail is displayed inline; clicking links to the full-resolution version:

```markdown
[![Alt text](thumb.png)](/path/to/full.png)
```

Thumbnails are typically `*thumb.png` or `*thumb.jpeg` files stored alongside their `*full.png` counterparts.

### Reflection Effect

Add to images or links wrapping images:

```markdown
![image](path){: .reflect .below-xl .round-sm }
```

Or in HTML: `<img class="reflect below-md round-none">`. The `below-*` modifier controls reflection gap; `round-*` controls corner radius.

### Floating Thumbnails

```markdown
![image](path){: .thumbnail }
```

Floats left (300px max). Use `.continued` on following paragraphs to keep text wrapping:

```markdown
{: .continued }
```

### Prompt Callouts

Use `<div>` tags (or Kramdown paragraph attributes) with these classes:

- `prompt-info` — informational (blue)
- `prompt-warning` — warning (yellow/amber)
- `prompt-error` — error (red/orange)

Each has a Font Awesome icon auto-added via `::before`.

### Inline Icons

Use empty `<i>` elements with icon CSS classes:

```html
<i class='apl-computer-imac-g4-17-256 reflect below-sm round-none'></i>
<i class="fa-solid fa-microchip"></i>
```

The `apl-*` classes render Apple system icons. The `jsb-*` classes render custom app icons (like `jsb-app-teskemon-256`). Choose the size suffix (-8 through -256) matching the desired display size.

### HTML Tables

Posts (especially retro-tech tutorials) frequently use HTML tables for side-by-side comparisons with images:

```html
<table>
  <thead><tr><th>Column 1</th><th>Column 2</th></tr></thead>
  <tbody>
    <tr>
      <td style="vertical-align: top;">content</td>
      <td style="vertical-align: top;">content</td>
    </tr>
  </tbody>
</table>
```

### Code Blocks

Standard fenced code blocks with language identifiers (`bash`, `xml`, `gdb`, etc.). No special syntax highlighting customization beyond minima's defaults (Rouge).

## Content Categories

Content categories, each with a landing page:

| Category | URL | Tag | Description |
|----------|-----|-----|-------------|
| Apps | `/apps/` | `Apps` | Jeffrey's self-built applications |
| Design | `/design/` | `Design` | UX design work (QoS redesign) |
| Retro-Tech | `/retro-tech/` | `Retro-Tech` | Vintage Mac/iPhone hacking projects |
| Unenshittification | `/unenshittification/` | `Unenshittification` | AI-assisted personal software and service reclamation projects |

Each category page uses the `home-category` layout and lists all posts in that category. The `titleAccessory` on each category page shows a large reflecting icon.

## Writing Tone and Style

- **First-person**, personal, and enthusiastic
- **Technical but approachable** — explains complex topics (reverse engineering, QoS, code signing) in detail without assuming expert knowledge
- **Long-form tutorials** for retro-tech posts; shorter overview + details for app/design posts
- **Humor and personality** — uses emoji, Font Awesome icons, and casual asides throughout
- **Jeff-centric** — always from Jeffrey's perspective and experiences

## Icon Pipeline (for reference)

The `scripts/` directory contains a 5-step pipeline for converting Mac `.icns` icon files to CSS classes and markdown reference tables:

| Script | Purpose |
|--------|---------|
| `icns0_EZtoStart.sh` | Master orchestrator — takes an ICNS folder and runs steps 2-4 |
| `icns1_FINDtoICNS.sh` | Finds and collects ICNS files |
| `icns2_ICNStoPNG.sh` | Converts ICNS to PNG at multiple sizes |
| `icns3_PNGtoCSS.sh` | Generates CSS classes from PNG icons |
| `icns4_CSStoMD.sh` | Generates markdown reference table from CSS |

Run with: `./icns0_EZtoStart.sh --input <ICNS folder>` from the repo root.

The reference page for all available icons is at `source/unlisted/icons.md` (excluded from site navigation).

## Other Notes

- **404 page**: Custom layout at `source/404.html` with its own inline CSS.
- **Gemfile** uses a GitHub reference for minima (not RubyGems). If you need to update it, pin a specific commit for stability.
- **Excluded from processing** (via `.gitignore`): `_site/`, `.sass-cache/`, `.jekyll-cache/`, `.jekyll-metadata`, `.bundle/`, `vendor/`, `.DS_Store`.
- The `source/` directory serves as the Jekyll root. All paths in config, includes, and layouts are relative to `source/`.
- **No plugins beyond jekyll-feed**. The minima theme also bundles `jekyll-seo-tag` for SEO metadata.
- The site's `url` is `https://jeffburg.com` and `baseurl` is empty (root domain deployment).
