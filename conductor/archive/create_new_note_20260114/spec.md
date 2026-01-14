# Specification: Create New Note Feature

## Overview
Implement a standardized workflow for creating new markdown notes in Neovim using `LazyNotes`. This feature streamlines the initial setup of a note by automating file creation, applying a YAML template, and handling naming conventions.

## Functional Requirements
- **Trigger Command**: The feature will be triggered by the Neovim command `:LazyNotesCreate`.
- **User Input**: Upon execution, the plugin will prompt the user for a note title using `vim.ui.input`.
- **Filename Generation**: 
    - Titles will be converted to kebab-case (e.g., "Daily Log 2026" becomes `daily-log-2026.md`).
    - Files will be created with a `.md` extension.
- **Note Template**: New files will be initialized with the following template:
    ```markdown
    ---
    date: YYYY-MM-DD
    tags: []
    ---

    # <Title>

    ```
    - The `date` field must be auto-populated with the current date in `YYYY-MM-DD` format.
    - The `<h1>` header should match the original title provided by the user.
- **File Management**:
    - The file will be created in the project's current working directory (root).
    - If the file already exists, the plugin should notify the user and abort (or open the existing file) to prevent overwriting.
- **Editing Experience**: Immediately after creation, the new file should be opened in the current buffer, and the cursor should be placed at the end of the file to start editing.

## Non-Functional Requirements
- **Minimal Dependencies**: Rely on standard Neovim API and `plenary.nvim` for path and file operations.
- **Performance**: Note creation should be instantaneous with no perceptible lag.

## Acceptance Criteria
- [ ] Running `:LazyNotesCreate` prompts for a title.
- [ ] Entering a title creates a kebab-case `.md` file in the CWD.
- [ ] The new file contains the YAML frontmatter with the correct current date.
- [ ] The new file contains a level 1 heading with the original title.
- [ ] The file is opened immediately after creation.
- [ ] Providing an empty title or canceling the prompt results in no file being created.

## Out of Scope
- Configurable templates (hardcoded for now).
- Configurable output directories (CWD only for now).
- Custom frontmatter fields beyond `date` and `tags`.
