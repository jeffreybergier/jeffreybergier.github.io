# AGENTS.md

This document provides guidance for AI agents working on this project to ensure consistency and efficiency.

## 1. Running the Project
The project is built using Jekyll. To run it locally using the system's Ruby and Bundler:

1.  **Navigate to the source directory**: `cd source`
2.  **Install dependencies**: `bundle install`
3.  **Run the server**: `bundle exec jekyll serve`
4.  **Access the site**: By default, the site will be available at `http://localhost:4000`.

## 2. Testing
The project currently does not have a programmatic test suite (e.g., RSpec or Capybara). Testing is primarily manual by running the Jekyll server and verifying the rendered output.

## 3. Theme and Features
The project uses the **Minima** theme as a base, with a **dark skin** enabled in `_config.yml`.

### Key Features:
- **Custom Layouts**:
    - `post.html`: Standard blog post layout.
    - `post-accessory.html`: A two-column layout featuring a primary content area and an accessory sidebar.
    - `page.html`: Standard page layout.
    - `home-category.html`: A landing page that filters and lists posts by a specific category.
- **Custom CSS Components**:
    - **Prompts**: Styled alert boxes (`.prompt-info`, `.prompt-warning`, `.prompt-error`) with integrated Font Awesome icons.
    - **Reflections**: A utility system for creating visual reflections on images using `-webkit-box-reflect`, with modifiers for distance (`.below-xs` to `.below-xl`) and corner radius (`.round-none` to `.round-lg`).
    - **Thumbnailing**: Floating thumbnail images with responsive overrides for mobile screens.

## 4. Owner Customizations
The owner has significantly extended the base Minima theme:
- **Custom Typography**: Overridden the body font to use a system-native Apple/Helvetica stack.
- **Icon System**: Implemented a massive library of custom CSS-based icons (found in `assets/css/_icons.scss`) mapping to various `.iconset` directories. These are used as `<i>` tags with specific classes (e.g., `.apl-app-finder-256`).
- **Layout Overrides**: Modified headers to support a `titleAccessory` variable, allowing images or icons to appear centered above the title.
- **Styling**: Overridden link colors and text decorations for a cleaner, high-contrast dark mode look.

## 5. Blog Post Structure
Blog posts are located in `_posts/` and use YAML front matter for configuration:

```yaml
---
layout: post # or post-accessory
title: "Post Title"
titleAccessory: "HTML/Markdown for the header icon"
excerpt: "Short summary for the index page"
categories: [CategoryName]
tags: [Tag1, Tag2]
---
```

Posts typically include:
- A lead-in image (often a thumbnail linking to a full-size image).
- A Table of Contents using the `{:toc}` Kramdown attribute.
- Structured sections using Markdown headers.

## 6. Custom Styles in Posts
Posts use Kramdown attributes to apply specific CSS classes directly to elements:

- **Thumbnails**: `![Alt text](/path/to/img.png){: .thumbnail }`
- **Reflections**: `![Alt text](/path/to/img.png){: .reflect .below-md .round-md }`
- **Links**: Using attributes like `{: target="_blank" }`.

## 7. Tone and Style
The writing style is:
- **Technical yet personal**: It reads like a developer sharing a journey or a project retrospective.
- **Direct and transparent**: Honest about development choices (e.g., "boring Model View Controller approach") and limitations (e.g., "not sandboxed").
- **Informative**: Provides clear download links, license info, and technical requirements.

## 8. Additional Notes
- **Assets**: Images and downloads are organized strictly under `assets/images` and `assets/downloads`.
- **Iconsets**: The project manages a huge collection of Apple-style iconsets. When adding new icons, ensure the `.iconset` folder contains the appropriate PNG sizes and the corresponding CSS is added to `_icons.scss`.
- **Production**: Comments are handled via an include (`comments.html`) and are only rendered in the `production` environment.
