# Specification: Configurable Keybindings

## Overview
Implement a flexible keybinding system for LazyNotes that provides sensible defaults while allowing full user customization.

## Functional Requirements
- **Default Mapping:**
    - `<leader>zn` should trigger `:LazyNotesCreate`.
    - This default should be applied automatically when `setup()` is called, unless disabled.
- **Customization:**
    - Users can override the default mapping via the `setup(opts)` function.
    - `opts.keys` table:
        - `opts.keys.create_note` (string): The key combination to trigger creation.
    - `opts.keys = false`: Disables all automatic keybindings.
- **Which-Key Integration:**
    - If `folke/which-key.nvim` is loaded, the plugin should register the `<leader>z` prefix with the label "LazyNotes".

## Acceptance Criteria
- [ ] calling `require("lazynotes").setup()` sets `<leader>zn` to `:LazyNotesCreate`.
- [ ] calling `setup({ keys = { create_note = "<leader>nn" } })` sets `<leader>nn` instead.
- [ ] calling `setup({ keys = false })` sets NO keybindings.
- [ ] If `which-key` is present, the group name is registered.

## Non-Functional Requirements
- **Safety:** Do not overwrite existing mappings without warning (though `vim.keymap.set` usually overrides).
- **Performance:** Keymap setup should be instant.
