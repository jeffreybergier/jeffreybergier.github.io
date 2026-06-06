# Agents Guide: Personal Blog Project

This project is a personal blog built using **Jekyll**, a static site generator. This file is intended to help LLMs and other agents understand the project structure and how to make updates.

## Project Structure

The project is organized with the source files located in the `source/` directory.

### Core Directories (`source/`)
- `_posts/`: Contains all blog posts in Markdown format. Filenames follow the `YYYY-MM-DD-title.md` convention.
- `_layouts/`: HTML templates for different page types (e.g., `post.html`, `page.html`, `home-category.html`).
- `_includes/`: Reusable HTML snippets (e.g., `nav-items.html`).
- `_data/`: YAML data files used for site-wide constants (`constants.yml`).
- `_drafts/`: Work-in-progress posts that are not yet published.
- `assets/`: Static assets:
    - `css/`: Stylesheets (Sass/CSS).
    - `images/`: Images categorized by topic (apps, design, retro-tech).
    - `icons/`: A large collection of `.iconset` directories containing multiple PNG sizes for icons.
    - `downloads/`: Files available for download.
- `unlisted/`: Markdown files that are not meant to be automatically processed into the main blog feed.

### Key Configuration Files
- `source/_config.yml`: The main Jekyll configuration file. Contains site title, URL, theme settings (Minima), and social links.
- `source/Gemfile`: Ruby dependencies for the Jekyll environment.

## Common Tasks for Agents

### Adding a New Blog Post
1. Create a new Markdown file in `source/_posts/`.
2. Ensure the filename starts with a date: `YYYY-MM-DD-name-of-post.md`.
3. Add YAML front matter at the top of the file (title, layout, date, etc.).
4. Add accompanying images to `source/assets/images/` in a relevant subfolder.

### Updating Site Metadata
- Modify `source/_config.yml` to update the site title, social links, or general configuration.

### Modifying Layouts/Design
- Edit files in `source/_layouts/` for structural changes.
- Edit files in `source/_includes/` for component-level changes.
- Modify `source/assets/css/style.scss` for visual styling.

### Handling Icons
- Icons are stored in `source/assets/icons/` as `.iconset` folders. Each folder contains different resolutions of the same icon (e.g., `icon_16x16.png`, `icon_512x512.png`).

## Technical Stack
- **Generator:** Jekyll
- **Theme:** Minima (Dark skin)
- **Language:** Ruby (via Gemfile)
- **Content Format:** Markdown
- **Styling:** Sass/CSS
