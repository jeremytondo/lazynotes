# Plan: Create New Note Feature

This plan outlines the implementation of the standardized note creation feature for `LazyNotes`, following a Test-Driven Development (TDD) approach.

## Phase 1: Foundation & Command Registration [checkpoint: 61d91aa]
- [x] Task: Register `:LazyNotesCreate` command and basic prompt logic (c233884)
    - [x] Create `lua/lazynotes/init.lua` if it doesn't exist or update it.
    - [x] Implement command registration using `vim.api.nvim_create_user_command`.
    - [x] Implement `vim.ui.input` call to capture user title.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Foundation & Command Registration' (Protocol in workflow.md)

## Phase 2: Core Logic - Filename & Template Generation
- [ ] Task: Implement kebab-case conversion utility
    - [ ] Create a utility function to transform "Title Case" to "kebab-case".
    - [ ] Add tests for various input formats (spaces, special characters, casing).
- [ ] Task: Implement template string generation
    - [ ] Create a function to generate the markdown content.
    - [ ] Ensure `date` is correctly formatted (YYYY-MM-DD).
    - [ ] Ensure the Level 1 header matches the user's input.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Core Logic - Filename & Template Generation' (Protocol in workflow.md)

## Phase 3: File System Integration & UX
- [ ] Task: Implement file writing logic
    - [ ] Use `plenary.path` for path manipulations.
    - [ ] Handle existing files (abort with notification if file exists).
    - [ ] Write the generated template to the filesystem.
- [ ] Task: Finalize UX: Open file and set cursor
    - [ ] Implement logic to open the newly created file in the current buffer.
    - [ ] Position the cursor at the end of the file.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: File System Integration & UX' (Protocol in workflow.md)
