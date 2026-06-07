# AGENTS.md – Jeffrey Bergier's GitHub Pages (jeffburg.com)

## Project Overview

This is a **Jekyll 4.4.1** static site built with the **Minima** theme (dark skin). It is the personal website of Jeffrey Bergier, hosted on GitHub Pages at `jeffburg.com`. The site covers three main topic areas: **Apps** (iOS/macOS app development), **Design** (industrial design & UX work), and **Retro Tech** (PowerPC Macs, old Apple hardware, reverse-engineering).

## How to Run the Project

### Prerequisites

The project expects **Ruby** (≥ 3.0) and **Bundler** (≥ 2.5) installed on the system. The `source/` directory is the Jekyll root.

### Local Development (Direct)

```bash
cd source
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

Then open `http://localhost:8080` in a browser.

### Docker Development

The project includes a `Dockerfile` and `docker-compose.yml` for containerized development:

```bash
docker build -t ruby-container .
docker-compose up -d
docker exec -it jekyll-environment bash
# Inside the container:
cd /source
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080
```

Then open `http://localhost:8080`.

### Production Build

```bash
cd source
bundle exec jekyll build
```

Output goes to `source/_site/`. This is what the GitHub Actions workflow deploys.

## How to Test

There is **no automated test suite**. Testing is done manually:

1. Run `bundle exec jekyll serve` and visually inspect the rendered site.
2. Run `bundle exec jekyll build` and verify no build errors appear. The build must succeed with zero warnings for a production deployment.
3. Check that all internal links resolve, images load, and layouts render correctly across desktop and mobile widths.

The CI/CD pipeline (`.github/workflows/gh-pages.yml`) performs `bundle exec jekyll build` on every push to `main`. A broken build in CI means the site will not deploy.

## Project Layout

```
.
├── Dockerfile                  # Debian-based Ruby container
├── docker-compose.yml          # Mounts ./source into container
├── scripts/                    # Icon processing pipeline scripts
├── source/
│   ├── _config.yml             # Jekyll config: theme, plugins, site settings
│   ├── Gemfile                 # Ruby dependencies (jekyll 4.4.1, minima from GitHub)
│   ├── Gemfile.lock            # Pinned dependency versions
│   ├── CNAME                   # Custom domain: jeffburg.com
│   ├── 404.html                # Custom 404 page (layout: page)
│   ├── index.md                # Homepage (layout: home, from Minima)
│   ├── apps.md                 # Apps category landing page
│   ├── design.md               # Design category landing page
│   ├── retro-tech.md           # Retro Tech category landing page
│   ├── _data/
│   │   └── constants.yml       # Shared data (category titles/URLs)
│   ├── _drafts/
│   │   └── IconSystem.md       # Draft post (not published)
│   ├── _includes/
│   │   └── nav-items.html      # Custom navigation items partial
│   ├── _layouts/
│   │   ├── home-category.html  # Layout for category landing pages
│   │   ├── post.html           # Layout for standard blog posts
│   │   ├── post-accessory.html # Layout for posts with sidebar content
│   │   └── page.html           # Layout for standalone pages (404, unlisted)
│   ├── _posts/                 # All published blog posts (8 posts, 2014–2026)
│   ├── assets/
│   │   ├── css/
│   │   │   ├── style.scss      # Main stylesheet (imports Minima + overrides)
│   │   │   └── _icons.scss     # Auto-generated icon CSS classes (~9850 lines)
│   │   ├── downloads/          # Downloadable files (e.g., installer zips)
│   │   ├── icons/              # .iconset folders with PNGs at various sizes
│   │   └── images/            # Post images organized by topic
│   └── unlisted/
│       └── icons.md            # Reference page showing all available icon classes
└── .github/workflows/
    └── gh-pages.yml            # CI/CD: auto-build and deploy to GitHub Pages
```

## Theme: Minima (Dark Skin, Heavily Customized)

The base theme is [Minima](https://github.com/jekyll/minima) (pinned to commit `c27c54a` via GitHub in the Gemfile). The `_config.yml` sets `minima.skin: dark` and `minima.show_excerpts: true`.

### CSS Customization (`source/assets/css/style.scss`)

The `style.scss` file imports Minima's default styles, then layers extensive overrides on top. Key customizations:

- **Typography**: Uses Apple system font stack (`-apple-system, BlinkMacSystemFont, …`). Link colors are bright white with underline offset styling for readability on dark backgrounds.
- **Header**: Removes the top border on `.site-header` and underlines from header links.
- **Clearfix**: Automatically applies clearfix after lists and paragraphs to handle floated images. The `.continued` class suppresses this clearfix, allowing text to keep wrapping around a floated image across multiple elements.
- **Thumbnail images**: The `.thumbnail` class floats an image left with `max-width: 300px`. On narrow screens (≤800px) it reverts to block display.
- **Accessory layout**: A flexbox-based two-column layout (`.accessory-layout`, `.al-accessory`, `.al-primary`) used by the `post-accessory` layout. The accessory column (left, ~30%) holds screenshots/sidebar content; the primary column (right, ~65%) holds the main text. On mobile, the columns stack vertically with the primary content first.
- **Title accessory**: The `.title-accessory` area places a decorative element (usually a large icon) above the post title. Max-width is `256px` on desktop, full-width on mobile.
- **Prompt callouts**: Three styled admonition types — `.prompt-info` (blue), `.prompt-warning` (amber), and `.prompt-error` (red) — each with a left border and Font Awesome icon via `::before`.
- **Reflection utilities** (see below).

### Icon System (`source/assets/css/_icons.scss`)

A custom icon system models macOS `.iconset` folders as CSS classes. Each icon set has size-based classes (e.g., `apl-app-finder-8`, `apl-app-finder-16`, `apl-app-finder-32`, `apl-app-finder-64`, `apl-app-finder-128`, `apl-app-finder-256`). Icons are rendered as `inline-block` elements with `background-image` from the iconset PNGs.

These are auto-generated by the scripts in `scripts/`:

1. `icns0_EZtoStart.sh` — Main entry point; orchestrates the pipeline
2. `icns1_FINDtoICNS.sh` — Finds ICNS files
3. `icns2_ICNStoPNG.sh` — Converts ICNS to PNG at multiple sizes
4. `icns3_PNGtoCSS.sh` — Generates CSS classes from the PNGs
5. `icns4_CSStoMD.sh` — Generates a Markdown reference table

Use these classes in Markdown via inline HTML: `<i class='apl-app-xcode-256 reflect below-md round-none'></i>`.

### Font Awesome 7

The site uses Font Awesome 7 (free) loaded via CDN (configured in the Minima head includes). Icons are referenced with classes like `fa-solid fa-swatchbook`, `fa-brands fa-github`, `fa-regular fa-hand-peace`, etc.

### Reflection Effect

A CSS-based reflection system gives images the classic macOS "shelf" reflection. Controlled by two class modifier groups:

| Distance Modifier | Effect |
|-------------------|--------|
| `.below-xl`       | 4px gap |
| `.below-lg`       | 0px gap |
| `.below-md`       | -16px (overlap) |
| `.below-sm`       | -32px (strong overlap) |
| `.below-xs`       | -38px (max overlap) |

| Radius Modifier | Border Radius |
|-----------------|--------------|
| `.round-none`   | 0            |
| `.round-sm`     | 0.5em        |
| `.round-md`     | 1em          |
| `.round-lg`     | 2em          |

Usage on an `<img>`: `{: .reflect .below-md .round-sm }` (Kramdown IAL). Usage on a link wrapping an image: apply `.reflect` to the `<a>`.

## Blog Post Structure

Every post is a Markdown file in `source/_posts/` named `YYYY-MM-DD-slug.md`.

### Front Matter

All posts share this front matter structure:

```yaml
---
layout: post                 # or post-accessory for posts with a sidebar
title: "Post Title"
titleAccessory: "<i class='icon-class-256 reflect below-md round-none'></i>"
excerpt: "A 1-2 sentence summary, supports markdown"
categories: [Apps|Design|Retro-Tech]
tags: [Apps, Hobby, ...]
---
```

**Important details:**
- `titleAccessory` is raw HTML/Markdown that renders above the post title. Typically a `<i>` element with an icon class and reflection modifiers. It is always wrapped in `{{ page.titleAccessory | markdownify }}` in the layout, so inline Kramdown IAL like `{: .reflect .below-md .round-none }` also work.
- `categories` must match exactly one of `Apps`, `Design`, or `Retro-Tech` — these are the three category pages the site uses. The `home-category` layout filters posts by `site.categories[page.category]`.
- `excerpt` is rendered with `markdownify` and displayed beneath the title. It appears on category listing pages too.
- The `layout` can be `post` (standard) or `post-accessory` (adds a left sidebar via the `accessory` front matter key). When using `post-accessory`, an additional `accessory:` key provides the sidebar content (typically a vertical stack of screenshot thumbnails with links to full-size images).

### Post Body Conventions

1. **Hero image/table**: Many posts open with an HTML `<table>` showing a beauty shot of hardware and a screenshot side by side. This is plain HTML, not Markdown.

2. **Table of Contents**: Posts consistently include a Kramdown-generated TOC:
   ```
   ## Table of Contents
   * TOC
   {:toc}
   ```
   The `{:toc}` Kramdown directive auto-generates a table of contents from the post's headings.

3. **Thumbnail images**: The standard image pattern is a clickable thumbnail linking to a full-size version:
   ```
   [![Alt text](/assets/images/.../01-thumb.png)](/assets/images/.../01-full.png){: .thumbnail }
   ```
   The `{: .thumbnail }` IAL is applied to the link (not the image). It floats the image left with a 300px max-width.

4. **Images with reflection**: App icons and hardware icons use the reflection system:
   ```
   [![App Icon](/assets/images/.../icon.png){: .reflect .below-xl .round-sm }](/some-link)
   ```

5. **Prompts/Callouts**: Use the prompt classes for warnings, notes, or errors:
   ```markdown
   This is a warning.
   {: .prompt-warning }
   ```

6. **Continued text**: When text needs to wrap around a floated image across multiple paragraphs, add `{: .continued }` to each paragraph that should flow:
   ```markdown
   First paragraph flows around the image.
   {: .continued }

   This paragraph also stays in the flow.
   {: .continued }
   ```

## Writing Tone and Style

- **First-person, personal voice**: All posts are written by Jeffrey in the first person. The tone is enthusiastic, knowledgeable, and conversational.
- **Self-aware and humble**: Frequent self-deprecating remarks ("I would not consider myself the best developer", "Some are good, some are bad").
- **Deeply technical but approachable**: Technical content is explained thoroughly with step-by-step walkthroughs, code snippets, and terminal output. Complex concepts are broken down for a general technical audience.
- **Hobbyist energy**: The retro-tech and app posts convey genuine excitement about the work. Emoji and Font Awesome icons are sprinkled inline (e.g., `<i class="fa-solid fa-hand-peace"></i>`).
- **Professional design posts**: The Design category posts (QoS Redesign) use a more polished, portfolio-style presentation — still first-person, but more structured around UX process (research, design, experimentation).
- **Mixed content types**: Some posts are purely written articles; others are heavily visual with annotated screenshots; the retro-tech posts are full tutorials with CLI commands, screenshots, and downloadable files.

## Key Technical Details for Future Agents

### Dependencies

The Gemfile pins `jekyll ~> 4.4.1` and uses Minima from GitHub at a specific commit (`c27c54a`). The `Gemfile.lock` is checked in and should be used for reproducible builds. The key plugins are `jekyll-feed` and `jekyll-seo-tag` (pulled in by Minima).

### Kramdown IAL (Inline Attribute Lists)

This project makes heavy use of Kramdown's `{: ... }` syntax to attach CSS classes and other attributes to preceding elements. This is Kramdown-specific — do not remove or alter these without understanding how they affect the rendered output.

Common patterns:
- `{: .thumbnail }` on images/links
- `{: .reflect .below-md .round-sm }` on reflected icons
- `{: .continued }` on paragraphs wrapping around floats
- `{: .prompt-warning }` or `{: .prompt-info }` on callout paragraphs
- `{:target="_blank"}` on external links

### Category Pages

The three category pages (`apps.md`, `design.md`, `retro-tech.md`) use `layout: home-category` and specify a `category` in their front matter. The layout filters `site.categories[page.category]` and renders a list of posts. If a category has no posts yet, it shows a "Coming Soon" placeholder. The homepage (`index.md`) uses Minima's built-in `home` layout.

### _data/constants.yml

This file provides reusable data for the homepage nav links. It has three keys (`retro-tech`, `design`, `apps`) each with `title` (HTML string including icon) and `url`. The homepage references these like `{{ site.data.constants.apps.title }}`.

### Excluded Content

The `_drafts/` directory and `unlisted/` directory are excluded from the build (Jekyll ignores `_drafts` by default; `unlisted/` content like `icons.md` has `exclude: true` in its front matter).

### Local Build Notes

- The `_site/` directory is git-ignored (generated output).
- `.sass-cache/`, `.jekyll-cache/`, `.bundle/`, and `vendor/` are all git-ignored.
- If you add new posts, always include both `-thumb` and `-full` versions of images for consistency with the existing conventions.

### Adding New Posts

1. Create `source/_posts/YYYY-MM-DD-slug.md`
2. Set the correct `layout`, `title`, `titleAccessory`, `excerpt`, `categories`, and `tags` in front matter
3. Include a hero image/table if appropriate
4. Add `## Table of Contents` + `* TOC {:toc}` after the hero section
5. If the post has sidebar screenshots, use `layout: post-accessory` and provide an `accessory:` key with the sidebar content
6. Place images under `source/assets/images/<topic>/<post-slug>/` with `-thumb` and `-full` naming
7. Build and visually verify before committing
