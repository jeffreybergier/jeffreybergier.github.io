# AGENTS.md — jeffreybergier.github.io

This document provides guidance for future AI agents (and humans) working on
this repository. It describes project structure, how to run and build the site,
theme customization details, content conventions, and writing style.

---

## Project Overview

This is a personal Jekyll blog deployed to GitHub Pages at
[jeffburg.com](https://jeffburg.com). The site is built with **Jekyll 4.4.1**
and uses the **Minima** theme (pinned to a GitHub ref). It is deployed via a
GitHub Actions workflow (`.github/workflows/gh-pages.yml`) that builds the site
and publishes to the `gh-pages` branch using `peaceiris/actions-gh-pages`.

The repository root is not the Jekyll root — the actual Jekyll site lives under
`./source/`. This is because the Docker setup mounts `./source` into the
container as `/source`.

### Directory Map

```
.
├── .github/workflows/gh-pages.yml   # CI: build & deploy to gh-pages
├── Dockerfile                        # Docker image with Ruby + Jekyll
├── docker-compose.yml                # Mounts ./source → /source, port 8080
├── scripts/                          # Icon pipeline shell scripts
│   ├── icns0_EZtoStart.sh            #  Orchestrator: ICNS → PNG → CSS → MD
│   ├── icns1_FINDtoICNS.sh           #  Find .icns files
│   ├── icns2_ICNStoPNG.sh            #  Convert ICNS to PNG
│   ├── icns3_PNGtoCSS.sh             #  Generate CSS from PNGs
│   └── icns4_CSStoMD.sh             #  Generate Markdown table from CSS
└── source/
    ├── _config.yml                   # Jekyll configuration
    ├── Gemfile                       # Ruby dependencies
    ├── Gemfile.lock
    ├── CNAME                         # "jeffburg.com"
    ├── 404.html                      # Custom 404 page
    ├── index.md                      # Home page (layout: home)
    ├── apps.md                       # Apps category page
    ├── design.md                     # Design category page
    ├── retro-tech.md                 # Retro Tech category page
    ├── _layouts/                     # Custom Jekyll layouts
    │   ├── home-category.html        # Category index page (apps, design, retro)
    │   ├── post.html                 # Standard blog post layout
    │   ├── post-accessory.html       # Post with left sidebar ("accessory")
    │   └── page.html                 # Generic page layout (404, icons)
    ├── _includes/
    │   └── nav-items.html            # Custom navigation include
    ├── _data/
    │   └── constants.yml             # Nav link data (title, url per category)
    ├── _posts/                       # Blog posts (YYYY-MM-DD-title.md)
    ├── _drafts/                      # Draft posts (one: IconSystem.md)
    ├── assets/
    │   ├── css/
    │   │   ├── style.scss            # Main stylesheet (imports Minima + _icons)
    │   │   └── _icons.scss           # Auto-generated icon CSS (9800+ lines)
    │   ├── icons/                    # PNG icon assets (hundreds of .iconset dirs)
    │   ├── images/                   # Blog post images & screenshots
    │   └── downloads/                # Downloadable assets (empty in repo)
    └── unlisted/
        └── icons.md                  # Unlisted icon gallery page (excluded from nav)
```

---

## How to Run the Project

### Option A: Docker (Recommended for Local Dev)

```bash
# Build the Docker image (one-time)
docker build -t ruby-container .

# Start the container in the background
docker-compose up -d

# Open a shell inside the container
docker exec -it jekyll-environment bash

# Inside the container:
cd /source
bundle install
bundle exec jekyll serve --host 0.0.0.0 --port 8080

# Open http://localhost:8080 in your browser
```

The `docker-compose.yml` mounts `./source` into the container as `/source` and
exposes port 8080. The Dockerfile installs Ruby, Ruby-Bundler, Ruby-dev, git,
build-essential, and the `bundler` + `jekyll` gems.

### Option B: Local Ruby (No Docker)

Prerequisites: Ruby (3.x), Bundler.

```bash
cd source
bundle install
bundle exec jekyll serve --port 4000
# Open http://localhost:4000
```

### Option C: Build Only (CI / Deployment)

```bash
cd source
bundle install
bundle exec jekyll build
# Output goes to source/_site/
```

The GitHub Actions workflow (`.github/workflows/gh-pages.yml`) does exactly this
on every push to `main` and deploys `source/_site/` to the `gh-pages` branch.

---

## Testing

**There are no automated tests in this project.** This is a personal blog with
no test framework configured. To manually verify changes:

1. Run `bundle exec jekyll build` and ensure it exits clean (no errors).
2. Run `bundle exec jekyll serve` and visually inspect the rendered pages.
3. Check that category pages (`/apps/`, `/design/`, `/retro-tech/`) list posts.
4. Check that individual posts render with their `titleAccessory` and custom
   styles intact.

If tests are added in the future, document them here.

---

## Theme: Minima with Customizations

### Base Theme

- **Theme**: [Minima](https://github.com/jekyll/minima) v3.0.0.dev, pinned to
  commit `c27c54a` in the Gemfile.
- **Skin**: `dark` (configured in `_config.yml` via `minima.skin: dark`).
- **Plugins**: `jekyll-feed ~> 0.12` (RSS/Atom feed generation).

### What `_config.yml` Controls

| Setting | Value | Notes |
|---|---|---|
| `title` | `Jeffrey Bergier` | Site title, used in header and `<title>` |
| `url` | `https://jeffburg.com` | Base URL for production |
| `theme` | `minima` | Jekyll theme gem |
| `minima.skin` | `dark` | Dark color scheme |
| `minima.show_excerpts` | `true` | Show post excerpts in lists |
| `minima.social_links` | GitHub, Mastodon, LinkedIn | Rendered as `fab` Font Awesome icons |
| `sass.load_paths` | `_sass` | Custom SCSS load path |

### Custom Styles (`assets/css/style.scss`)

The main stylesheet imports Minima's skin and initialization, then imports the
auto-generated `_icons.scss`. After that, it defines a large block of overrides:

| Feature | Description |
|---|---|
| **Body font** | System font stack (`-apple-system`, `BlinkMacSystemFont`, etc.) with light gray text (`#CFCFCF`) on dark background |
| **Link styling** | White links (`#FFF`) with underline; darken on hover/active (`#aaa`) |
| **Header links** | Underlines removed via `.site-header a { text-decoration: none; }` |
| **Header border** | Top border removed |
| **Clearfix for lists & paragraphs** | `.home` and `.post-content` blocks use `::after { clear: both }` pseudos |
| **`.continued` class** | Removes the clearfix — allows text to flow around floated images |
| **`.thumbnail` images** | Left-floated, `max-width: 300px`, responsive (full-width below 800px) |
| **Accessory layout** | Flexbox sidebar layout (`.accessory-layout` → `.al-accessory` + `.al-primary`). On small screens the accessory stacks below the primary content |
| **Title accessory** | Centered, `max-width: 256px`; useful for placing app icons above post titles |
| **`.prompt-info/warning/error`** | Callout boxes with colored left borders and Font Awesome icon prefixes (info=blue, warning=yellow, error=red) |
| **Reflection utilities** | CSS custom properties for `-webkit-box-reflect` with distance modifiers (`below-xl` through `below-xs`) and corner radius modifiers (`round-none` through `round-lg`) |

### Custom Icon System (`assets/css/_icons.scss`)

This is a massive (9800+ line) auto-generated SCSS file. It defines CSS classes
for displaying Apple-style icons at various sizes (8px, 16px, 64px, 256px) as
inline-block elements with background images. The format is:

```css
.apl-{category}-{name}-{size} {
  display: inline-block;
  width: {size}px;
  height: {size}px;
  background-image: url('/assets/icons/{path}/icon_{larger}px.png');
  background-size: {size}px {size}px;
}
```

Icons are used as `<i>` elements in Markdown, e.g.:
```html
<i class='apl-app-xcode-256 reflect below-sm round-none'></i>
```

The icon pipeline (`scripts/icns0_EZtoStart.sh`) converts ICNS files to PNGs,
generates this CSS, and produces the `unlisted/icons.md` reference gallery.

---

## Blog Post Structure

### File Naming

Posts live in `source/_posts/` and follow the Jekyll naming convention:
`YYYY-MM-DD-slug.md`.

### Front Matter

Every post has YAML front matter. The fields used (depending on layout):

```yaml
---
layout: post                  # or post-accessory
title: "Post Title"
titleAccessory: "<i class='...'></i>"  # Optional icon/image above the title
excerpt: "Short description"
categories: [Apps]            # or [Design], [Retro-Tech]
tags: [Apps, Hobby]
accessory: |                 # Only for post-accessory layout — a markdown sidebar
  ![screenshot](url)
modified_date: 2025-12-10    # Optional — shows "Updated:" in post meta
---
```

### Layout Choices

| Layout | File | Use Case |
|---|---|---|
| `post` | `_layouts/post.html` | Standard blog post. Includes `titleAccessory` above title, post meta (date, author), content, and comments placeholder |
| `post-accessory` | `_layouts/post-accessory.html` | Post with a left sidebar column. The `accessory` front-matter field is rendered in the sidebar; main `content` is in the right column. Uses the `.accessory-layout` flexbox |
| `home-category` | `_layouts/home-category.html` | Used by `apps.md`, `design.md`, `retro-tech.md`. Shows the page content then lists all posts in the specified `category` |
| `home` | (Minima built-in) | Used by `index.md` (the homepage) |
| `page` | `_layouts/page.html` | Generic page (404, icons gallery) |

### Category Pages

Each category page (`apps.md`, `design.md`, `retro-tech.md`) uses the
`home-category` layout. The `category` front-matter value maps to a Jekyll
category (`site.categories[page.category]`). The layout renders the page's own
content first, then loops through matching posts and lists them.

The `nav-items.html` include renders navigation links by finding pages by path
and using their `title` field. The `title` fields for category pages contain
Font Awesome icons inline (e.g. `<i class="fa-solid fa-compass-drafting"></i> Apps`).
Note: the nav include comment says `<!-- Removed | escape -->` — the titles are
rendered raw (unescaped) so the HTML icons work.

---

## Custom Styles in Blog Posts

Posts use Kramdown inline attribute lists to apply CSS classes to Markdown
elements. Common patterns:

### Thumbnail Images
```markdown
![alt](/path/to/image.png){: .thumbnail }
```
Left-floats the image at max 300px width with text flowing around it.

### Reflection Effects
```markdown
![alt](/path/to/image.png){: .reflect .below-xl .round-sm }
```
Adds a WebKit box-reflect effect below the image with configurable distance and
corner radius. The `reflect` class can be applied to `<img>` directly or to an
`<a>` wrapping an `<img>`.

### Title Accessories
```markdown
titleAccessory: "<i class='apl-app-xcode-256 reflect below-sm round-none'></i>"
```
Often used in front matter to put a large Apple-style icon above the post title.

### Continued Text Flow
```markdown
This paragraph flows around a floated image.
{: .continued }
```
Prevents the automatic clearfix, allowing text to continue wrapping.

### Prompt Callout Boxes
```html
<div class="prompt-info">
...
</div>
```
Styled callout boxes with colored left borders and Font Awesome icons. Three
variants: `prompt-info` (blue), `prompt-warning` (yellow), `prompt-error` (red).

### Accessory Sidebar (post-accessory layout)
The `accessory` front-matter field takes arbitrary markdown and renders it in
a 30% sidebar column to the left of the main content. Used by the Gratuity post
to show screenshots alongside the article.

### Tables
Standard Markdown tables are used. Some posts wrap them in `<table>` HTML for
finer control (e.g., `Reverse-iTunes-1` uses a table to show a beauty shot and
screenshots side by side).

### Font Awesome Icons
Posts freely use Font Awesome 6/7 icons inline:
```html
<i class="fa-solid fa-microscope"></i>
<i class="fa-brands fa-github"></i>
```
These are used in navigation titles, post body text, and download links.

---

## Writing Tone and Style

Jeffrey Bergier's writing is **conversational, personal, and enthusiastic**.
Key characteristics:

- **First-person narrative.** Most posts are written in "I" statements — "I
  wanted to learn Swift," "I was extremely suspicious of this..."
- **Self-deprecating humor.** He undercuts his own expertise: "I would not
  consider myself the best developer out there," "Needless to say, it was not
  the greatest Swift code."
- **Deep technical detail.** Posts mix casual storytelling with genuinely
  deep technical content — GDB debugging commands, XML protocol analysis,
  architectural discussion of Model/View/Controller.
- **Emoji/icon usage in prose.** Font Awesome icons are used as inline
  emotional punctuation: skull-and-crossbones for danger, surprised face for
  amazement, ninja for stealth.
- **Journey-oriented.** Posts describe the *process* of discovery, not just
  the result. Sections like "But Why" and "Approach" walk through motivation
  and methodology.
- **Balanced perspective.** He acknowledges limitations and caveats
  ("hacker beware"), and doesn't oversell his projects.
- **Topic range.** Content spans three categories:
  - **Apps** — iOS/macOS development (Swift, Objective-C, SwiftUI)
  - **Design** — UX research, industrial design, QoS architecture
  - **Retro Tech** — Reverse engineering old Macs, iPhone syncing, PowerPC
    hardware hacking

When writing **new posts or editing existing ones**, maintain this tone:
personal but technically rigorous, humble but not falsely so, enthusiastic
about the craft, and always clear about caveats and limitations.

---

## Icon Pipeline

The `scripts/` directory contains a multi-stage pipeline for converting Apple
`.icns` icon files into CSS classes and a Markdown reference gallery.

**Orchestrator**: `icns0_EZtoStart.sh` takes an `--input` folder of `.icns`
files and runs the full pipeline:

1. `icns1_FINDtoICNS.sh` — Find `.icns` files
2. `icns2_ICNStoPNG.sh` — Convert ICNS → PNG at multiple resolutions
3. `icns3_PNGtoCSS.sh` — Generate `_icons.scss` CSS classes from PNGs
4. `icns4_CSStoMD.sh` — Generate `unlisted/icons.md` reference table

These scripts require macOS (for `iconutil` and `sips`). They are not used in
CI — only run manually on a Mac when new icons are added.

---

## Deployment

1. Push to `main` (or merge a PR to `main`).
2. GitHub Actions workflow `.github/workflows/gh-pages.yml` triggers.
3. It sets up Ruby 3.3, runs `bundle install` inside `./source`, then
   `bundle exec jekyll build`.
4. The `peaceiris/actions-gh-pages@v4` action publishes `./source/_site` to the
   `gh-pages` branch.
5. GitHub Pages serves the site at `jeffburg.com` (configured via `CNAME`).

The custom domain (`jeffburg.com`) is set in the `source/CNAME` file. GitHub
Pages uses this to configure the custom domain automatically.

---

## Common Tasks for Agents

### Adding a New Blog Post

1. Create `source/_posts/YYYY-MM-DD-slug.md`.
2. Set the front matter:
   - `layout: post` (or `post-accessory` for sidebar content).
   - `title`, `excerpt`, `categories`, `tags`.
   - Optionally `titleAccessory` with an icon `<i>` tag.
3. Write the post body in Markdown with Kramdown inline attribute lists for
   styling (`.thumbnail`, `.reflect`, etc.).
4. Use `{:toc}` to auto-generate a table of contents from headings.
5. Build and preview: `cd source && bundle exec jekyll serve`.

### Adding a New Category Page

1. Create `source/new-category.md`.
2. Use `layout: home-category`.
3. Set `category: NewCategory` (must match the category string used in posts'
   `categories` front matter).
4. Set `permalink`, `title` (with optional inline Font Awesome icon HTML).
5. Add the category page path and title to `_data/constants.yml` so it appears
   in navigation.

### Adding New Icons

1. Place `.icns` files in a folder on macOS.
2. Run `scripts/icns0_EZtoStart.sh --input /path/to/icns`.
3. This regenerates `assets/css/_icons.scss` and `unlisted/icons.md`.

### Modifying Styles

Edit `source/assets/css/style.scss`. This file imports Minima's default skin,
imports `_icons`, then applies overrides. Structure custom styles below the
`/* Now add your overrides */` comment.

---

## Key Dependencies

| Dependency | Version | Notes |
|---|---|---|
| Jekyll | ~> 4.4.1 | Static site generator |
| Minima | GitHub: `c27c54a` | Jekyll theme (v3.0.0.dev) |
| jekyll-feed | ~> 0.12 | RSS feed plugin |
| Ruby | 3.3 (CI) | CI uses `ruby/setup-ruby@v1` |
| GitHub Pages | N/A | Site is deployed via `peaceiris/actions-gh-pages`, not native GitHub Pages build |
