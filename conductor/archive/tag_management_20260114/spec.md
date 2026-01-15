# Specification: Tag Management and Autocompletion

## Overview
This track implements the core tag management system for LazyNotes. It focuses on maintaining a centralized `tags.json` file as the source of truth, providing commands to sync and manage tags, and integrating with `blink.cmp` to provide intelligent autocompletion strictly within note frontmatter.

## Functional Requirements
- **Centralized Tag Storage:**
    - Use `.lazynotes/tags.json` at the project root as the exclusive source of truth for valid tags.
    - Format: A JSON file containing a flat list of unique tag strings.
- **Tag Acquisition:**
    - **Command `LazyNotesAddTag`:** Prompt the user for a single tag and add it to the JSON file.
    - **Auto-Update on Save:** When a markdown file is saved, parse its YAML frontmatter. Any tags not present in `tags.json` must be added automatically.
    - **Command `LazyNotesSyncTags`:** Scan all markdown files in the project root, extract all unique tags from frontmatter, and update `tags.json` to include any missing ones.
- **Project Initialization:**
    - Automatically create the `.lazynotes/` directory and an empty `tags.json` file if they do not exist when a tag operation (add, save, or sync) is triggered.
- **Autocompletion (`blink.cmp` Integration):**
    - Implement a custom `blink.cmp` source.
    - **Context Awareness:** Suggestions should **only** trigger when the cursor is within the `tags: [...]` list in the YAML frontmatter.
    - **Performance:** Suggestions should be fetched from the cached `tags.json` file.

## Non-Functional Requirements
- **Efficiency:** The tag sync should be non-blocking or optimized to prevent UI lag in large projects.
- **Robustness:** Handle malformed YAML or JSON gracefully without crashing the editor.

## Acceptance Criteria
- [ ] `tags.json` is correctly updated when running `LazyNotesAddTag`.
- [ ] Saving a file with new tags in the frontmatter automatically adds them to `tags.json`.
- [ ] `LazyNotesSyncTags` correctly identifies all tags across the project and updates the JSON file without deleting existing entries.
- [ ] Autocompletion via `blink.cmp` works correctly inside the `tags` array in YAML frontmatter.
- [ ] Autocompletion does not trigger outside of the frontmatter `tags` block.

## Out of Scope
- Management of tags outside of YAML frontmatter (e.g., inline hashtags).
- Automatic pruning or removal of tags from `tags.json`.
- Complex tag metadata (usage counts, categories).
