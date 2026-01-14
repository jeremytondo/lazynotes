# Plan: Tag Management and Autocompletion

## Phase 1: Tag Storage and Project Initialization
Setup the core IO logic for managing the `.lazynotes/tags.json` file and handling project discovery.

- [x] Task: Implement `io.get_root()` to identify project root based on `.lazynotes` or git. a6d7618
- [x] Task: Implement `io.init_project()` to create `.lazynotes/tags.json` if missing. a6469be
- [x] Task: Implement `io.read_tags()` and `io.write_tags()` with basic error handling. ad7fcb8
- [x] Task: Write tests for project initialization and tag IO. ad7fcb8
- [x] Task: Implement to pass tests. ad7fcb8
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Storage' (Protocol in workflow.md)

## Phase 2: Tag Management Commands and Logic
Implement the logic for adding, parsing, and syncing tags across the project.

- [ ] Task: Implement `tags.add_tag(tag)` logic to update the JSON file.
- [ ] Task: Create `LazyNotesAddTag` command using `vim.ui.input`.
- [ ] Task: Implement frontmatter parser to extract tags from a buffer/file.
- [ ] Task: Implement `LazyNotesSyncTags` to scan all markdown files and update `tags.json`.
- [ ] Task: Write tests for tag parsing and syncing logic.
- [ ] Task: Implement to pass tests.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Management' (Protocol in workflow.md)

## Phase 3: Auto-Update on Save
Integrate the tag acquisition logic into the Neovim buffer save workflow.

- [ ] Task: Create an `autocmd` for `BufWritePost` on markdown files.
- [ ] Task: Implement logic to trigger tag extraction and update `tags.json` on save.
- [ ] Task: Write tests to verify `tags.json` updates after simulated buffer writes.
- [ ] Task: Implement to pass tests.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Auto-Update' (Protocol in workflow.md)

## Phase 4: Blink.cmp Integration
Implement the custom completion source to provide fuzzy tag suggestions.

- [ ] Task: Scaffold a basic `blink.cmp` source for LazyNotes.
- [ ] Task: Implement context detection (is cursor in frontmatter tags array?).
- [ ] Task: Connect the completion source to `io.read_tags()`.
- [ ] Task: Register the source with `blink.cmp`.
- [ ] Task: Write integration tests for completion triggers.
- [ ] Task: Implement to pass tests.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Autocompletion' (Protocol in workflow.md)
