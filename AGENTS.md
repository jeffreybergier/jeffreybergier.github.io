# AGENTS.md

This project is a personal blog built using **Jekyll**. This file provides guidance for AI agents and LLMs to help maintain and update the blog.

## Project Structure

The project follows a standard Jekyll structure, with the source files located in the `source/` directory.

### Core Directories (`/source`)
- `_posts/`: Contains all blog posts in Markdown format. Filenames must follow the `YYYY-MM-DD-title.md` pattern.
- `_layouts/`: Defines the HTML templates for different content types (e.g., `post.html`, `page.html`).
- `_includes/`: Contains reusable HTML snippets (e.g., `nav-items.html`).
- `_data/`: Contains YAML files for global data (e.g., `constants.yml`).
- `_drafts/`: Contains posts that are not yet ready for publication.
- `assets/`: Static files.
    - `css/`: Stylesheets (SCSS).
    - `images/`: Images organized by category (e.g., `apps/`, `design/`, `retro-tech/`).
    - `icons/`: A large collection of `.iconset` folders containing various icon sizes.
    - `downloads/`: Files available for download.

### Root Files
- `_config.yml`: Global Jekyll configuration.
- `index.md`: The homepage content.
- `apps.md`, `design.md`, `retro-tech.md`: Top-level pages.
- `404.html`: Custom 404 page.

## Development Guidelines

### Adding a New Post
1. Create a new Markdown file in `source/_posts/`.
2. Use the naming convention: `YYYY-MM-DD-slug.md`.
3. Add a YAML front matter block at the top of the file (title, date, categories, etc.).

### Updating Site Structure
- To modify the navigation, check `source/_includes/nav-items.html`.
- To change global site settings, edit `source/_config.yml`.

### Handling Icons
The project has a specialized icon system located in `source/assets/icons/`. Each icon is stored in its own `.iconset` directory. There are scripts in the `/scripts` directory that may be used to manage these icons.

### Styling
Custom styles are located in `source/assets/css/`. The main stylesheet is `style.scss`, and icons are handled in `_icons.scss`.

## Tech Stack
- **Static Site Generator**: Jekyll
- **Styling**: SCSS
- **Content**: Markdown / YAML
- **Deployment**: Docker (see `Dockerfile` and `docker-compose.yml`)
