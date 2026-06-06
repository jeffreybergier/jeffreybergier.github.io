# Agents Guide: Jeffrey Bergier's Personal Blog

This document provides the necessary context, structural layout, and stylistic guidelines for LLMs assisting in the maintenance and expansion of this Jekyll-based personal blog.

## Project Overview
- **Purpose**: A personal blog for sharing software development projects, reverse engineering experiments, and retro-tech hobbies.
- **Framework**: [Jekyll](https://jekyllrb.com/)
- **Theme**: Minima (dark skin)
- **Base URL**: `https://jeffburg.com`

## Project Structure
The project follows a standard Jekyll layout with some custom additions:

- `/source`: The root of the Jekyll site.
    - `_config.yml`: Global site settings and Minima theme configuration.
    - `_posts/`: Markdown files for blog posts. Filenames must follow `YYYY-MM-DD-title.md`.
    - `_layouts/`: HTML templates (e.g., `post.html`, `page.html`).
    - `_includes/`: Reusable HTML snippets.
    - `assets/`:
        - `css/style.scss`: Custom SCSS overrides for the Minima theme.
        - `images/`: Organized by category (e.g., `/apps`, `/design`, `/retro-tech`).
        - `icons/`: Contains `.iconset` folders used for custom app/device icons.
    - `index.md`: Home page.
    - `*.md`: Static pages (e.g., `design.md`, `retro-tech.md`).
- `/scripts`: Utility scripts for processing icons (ICNS $\rightarrow$ PNG $\rightarrow$ CSS $\rightarrow$ MD).

## Content & Writing Style
The author's writing style is a blend of technical precision and personal enthusiasm. When generating or editing content, adhere to these guidelines:

- **Tone**: Enthusiastic, curious, and transparent. The author often shares their thought process, including failures and "wrong turns" (e.g., "I was totally failing to find a whitelist...").
- **Structure**:
    - **Front Matter**: Every post requires layout, title, excerpt, categories, and tags.
    - **TOC**: Most posts include a Table of Contents using `{:toc}` or `{::options toc_levels="1,2,3" /}`.
    - **TL;DR**: For technical tutorials, provide a "TL;DR" section early in the post to summarize the solution.
    - **Narrative Flow**: Technical posts often follow a "Problem $\rightarrow$ Hypothesis $\rightarrow$ Trial/Error $\rightarrow$ Solution" narrative.
- **Visuals**: Frequent use of thumbnails linked to full-size images.
    - **Format**: `[![Alt Text](/path/to/thumb.png)](/path/to/full.png)`
    - **Alignment**: Use `{: .thumbnail }` for floating images.
- **Personality**: Use a few well-placed emojis (e.g., $\text{<i class="fa-solid fa-user-ninja"></i>}$, $\text{<i class="fa-regular fa-face-surprise"></i>}$) to emphasize a point or emotion, but keep them sparse.

## Technical Layout & CSS Guidelines
The blog uses specific CSS classes for layout and visual effects:

### 1. Accessory Layout
Used for posts that need a sidebar or a specific header icon.
- **`titleAccessory`**: Defined in Front Matter. Uses `<i>` tags with custom icon classes.
- **`.accessory-layout`**: A flexbox wrapper.
    - `.al-primary`: Main content area (~65%).
    - `.al-accessory`: Side content area (~30%).

### 2. Reflection Utilities
Used for "Apple-style" reflections on images/icons.
- **Classes**: `.reflect`
- **Distance Modifiers**: `.below-xl`, `.below-lg`, `.below-md`, `.below-sm`, `.below-xs`.
- **Radius Modifiers**: `.round-none`, `.round-sm`, `.round-md`, `.round-lg`.
- **Usage**: `![Alt](/path/to/img.png){: .reflect .below-md .round-md }`

### 3. Prompt Styling
For callouts within posts:
- `.prompt-info`: Blue background, info icon.
- `.prompt-warning`: Yellow background, warning icon.
- `.prompt-error`: Red background, error icon.

## Instructions for LLM Assistants
1. **When adding a new post**:
    - Ensure the filename is correctly dated.
    - Create an appropriate `titleAccessory` if the post is about an app or device.
    - Include a `TL;DR` if it's a technical guide.
    - Use the `.thumbnail` class for screenshots.
2. **When updating CSS**:
    - Maintain the dark theme aesthetic (`#CFCFCF` text, `#FFF` links).
    - Use SCSS nesting as established in `style.scss`.
3. **When managing assets**:
    - Place images in the corresponding category folder under `source/assets/images/`.
    - Provide both a `-thumb.png` and a `-full.png` version for screenshots.
