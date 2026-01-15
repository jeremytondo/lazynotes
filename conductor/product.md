# Initial Concept

This project is going to be a Nevoim Lua plugin that works in conjunction with the features provided in the LazyVim Neovim Distribution. Here are some details on the idea I'm trying to build.

# LazyNotes

LazyNotes is an idea for a Neovim plugin that adds some additional features useful for managing notes in markdown.

For the most part I've found that LazyVim has a fairly complete set of features useful for managing markdown notes. There are just a few things that I wanted for my own workflow and this plugin fills those gaps.

I looked at plugins like obsidian.nvim, but found that I didn't really need all of those features. LazyVim already provides so much out of the box, I just needed a few additional things.

In general, the goal is to keep the scope of this plugin as limited as possible and rely on plugins and extras already included in the LazyVim distribution.

## LazyNotes features
LazyNotes attempts to provide the following features:

### Standardized Note Creation
Quickly create new notes that follow a specific template. This includes some yaml frontmatter to help keep notes organized.

Simple notes template:

```markdown
---
date: 2026-01-13
tags: []
---

# Note Title

Markdown notes go here.
```

The plugin should expose a command that prompts the user for the title of the note and then creates the note markdown file based on the template, opens it, and places the user at the end to start editing.

### Tagging
I like to add some extra notes organization with tags. This feature helps manage tags and provides autocompletion when adding tags to a note.

This feature uses a centralized JSON file in the root of the current folder to store unique tags.

`.lazynotes/tags.json`

Tags are automatically extracted from note frontmatter on save, and can be manually synchronized across the project or added individually. Tags are normalized to `kebab-case` to ensure consistency.

**Key Tagging Features:**
- **Auto-Acquisition:** New tags in frontmatter are added to the library on file save.
- **Manual Sync:** Scan all markdown files in the project to rebuild the tag library.
- **Normalization:** Consistent formatting (kebab-case) for all stored tags.

### Configuration
LazyNotes supports both global configuration via `setup()` and project-local configuration via `.lazynotes/config.json`. This allows for fine-grained control over features like `.gitignore` awareness on a per-project basis.

#### Tag autocompletion
If a user is editing the tags block inside the yaml frontmatter of a markdown file that is inside a project that contains a .lazynotes folder at its root, we should provide autocompletion of those tags via blink.cmp. This will allow nice features like fuzzy finding tags as a user types.


## LazyVim Plugins
Here are some of the key plugins that are part of LazyVim that this plugin will rely on.

### Marksman
https://github.com/artempyanykh/marksman

Marksman is an LSP for markdown files. I've found it incredibly useful for features like completion, goto definition, find references, rename refactoring, diagnostics, and wiki link style references.

### Blink.cmp
https://github.com/saghen/blink.cmp

Completion plugin that's used to provide tag fuzzy finding and autocompletion.

# Product Guide: LazyNotes

## Product Vision
LazyNotes is a lightweight Neovim Lua plugin designed specifically for LazyVim users. It aims to bridge the small gaps in the LazyVim ecosystem for markdown note management, adhering to a "minimal scope" philosophy by leveraging existing high-quality plugins like Marksman and blink.cmp.

## Target User Personas
- **LazyVim Power Users:** Individuals who already enjoy the LazyVim experience and want a native-feeling, lightweight addition for structured note-taking without the overhead of a full-featured system like obsidian.nvim.

## Core Goals
- **Minimalism:** Provide only the essential features missing from LazyVim's markdown support.
- **LazyVim Synergy:** Integrate seamlessly with the plugins and "extras" already bundled with LazyVim.
- **Efficiency:** Streamline the creation and organization of markdown notes through standardization and smart autocompletion.

## Key Features
- **Standardized Note Creation:**
    - Command-driven workflow to prompt for a title.
    - Automatic generation of notes based on a standard template with YAML frontmatter (date, tags).
    - Immediate navigation to the new file for editing.
- **Tag Management System:**
    - Centralized tag storage in a `.lazynotes/tags.json` cache file at the project root.
    - Persistent and consistent tagging across the project.
- **Intelligent Autocompletion:**
    - Deep integration with `blink.cmp` to provide fuzzy-finding and autocompletion for tags within the YAML frontmatter.
- **LSP & Search Integration:**
    - Leveraging `marksman` for core markdown LSP functionality.
    - Integration with `telescope.nvim` or `fzf-lua` for efficient note discovery.

## Storage & Organization
- **Flat Structure:** Notes are stored in a flat directory at the root of the project to maintain simplicity and ease of access.
- **Project Root Discovery:** The presence of a `.lazynotes` folder at the project root serves as the anchor for plugin functionality and cache storage.