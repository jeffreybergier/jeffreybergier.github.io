# Agent Guide for Jeffrey Bergier's Personal Blog

This document provides a structural overview of this project to help LLMs and automated agents understand the layout, technology stack, and conventions used in this personal blog.

## Project Overview
- **Purpose**: Personal blog and portfolio.
- **Framework**: [Jekyll](https://jekyllrb.com/) (Static Site Generator).
- **Theme**: Minima (Dark skin).
- **Source Directory**: `/source`

## Directory Structure

### Core Content (`/source`)
- `_config.yml`: Global site settings, including URL, title, and social links.
- `index.md`: The homepage of the blog.
- `_posts/`: Contains blog posts in Markdown format. Filenames follow the `YYYY-MM-DD-title.md` convention.
- `_layouts/`: HTML templates for different page types:
    - `post.html`: Layout for blog posts.
    - `page.html`: Layout for static pages.
    - `home-category.html`: Specialized layout for category-based home views.
- `_includes/`: Reusable HTML fragments (e.g., `nav-items.html`).
- `_data/`: YAML data files for site-wide constants (`constants.yml`).
- `_drafts/`: Work-in-progress posts not yet published.
- `unlisted/`: Pages that are part of the source but not intended for main navigation.

### Assets (`/source/assets`)
- `css/`: Stylesheets (SASS/CSS).
- `images/`: Organized by category:
    - `apps/`: Screenshots and assets for software projects (e.g., `gratuity`, `teskemon`).
    - `design/`: Design-related assets (e.g., `qos`).
    - `retro-tech/`: Assets for retro computing posts.
- `icons/`: A large collection of `.iconset` folders containing various PNG sizes for system and app icons.
- `downloads/`: Files available for download by visitors.

### Tooling (`/scripts`)
- Contains shell scripts (`.sh`) used for processing icons (converting `.iconset` to PNG, CSS, and Markdown).

## Conventions for Updates

### Adding a New Post
1. Create a file in `_posts/` named `YYYY-MM-DD-title.md`.
2. Add YAML front matter (at least `layout: post` and `title: Your Title`).
3. Use Markdown for the content.
4. Place associated images in `source/assets/images/` under a relevant subfolder.

### Adding a New Page
1. Create a `.md` file in the root of `/source`.
2. Add YAML front matter (e.g., `layout: page`).

### Modifying Styles
1. Edit files in `source/assets/css/` (specifically `style.scss`).

## Deployment & Build
- The project is containerized using **Docker** (`Dockerfile`, `docker-compose.yml`).
- To build/serve locally, use the provided Docker configuration.
