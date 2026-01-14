# Plan: Create New Note Feature

This plan outlines the implementation of the standardized note creation feature for `LazyNotes`, following a Test-Driven Development (TDD) approach.

## Phase 1: Foundation & Command Registration [checkpoint: 61d91aa]
- [x] Task: Register `:LazyNotesCreate` command and basic prompt logic (c233884)
    - [x] Create `lua/lazynotes/init.lua` if it doesn't exist or update it.
    - [x] Implement command registration using `vim.api.nvim_create_user_command`.
    - [x] Implement `vim.ui.input` call to capture user title.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Foundation & Command Registration' (Protocol in workflow.md)

## Phase 2: Core Logic - Filename & Template Generation [checkpoint: 4bb1c2e]
- [x] Task: Implement kebab-case conversion utility (44cefb7)
    - [x] Create a utility function to transform "Title Case" to "kebab-case".
    - [x] Add tests for various input formats (spaces, special characters, casing).
- [x] Task: Implement template string generation (9907480)
    - [x] Create a function to generate the markdown content.
    - [x] Ensure `date` is correctly formatted (YYYY-MM-DD).
    - [x] Ensure the Level 1 header matches the user's input.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Core Logic - Filename & Template Generation' (Protocol in workflow.md)

## Phase 3: File System Integration & UX [checkpoint: 927687d]
- [x] Task: Implement file writing logic (1ed37d3)
    - [x] Use `plenary.path` for path manipulations.
    - [x] Handle existing files (abort with notification if file exists).
    - [x] Write the generated template to the filesystem.
- [x] Task: Finalize UX: Open file and set cursor (e3a72ff)
    - [x] Implement logic to open the newly created file in the current buffer.
    - [x] Position the cursor at the end of the file.
- [x] Task: Implement title case conversion for note header (d134345)
    - [x] Add `to_title_case` utility to `format.lua`.
    - [x] Update `:LazyNotesCreate` to use `to_title_case` for the note content.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: File System Integration & UX' (Protocol in workflow.md)
