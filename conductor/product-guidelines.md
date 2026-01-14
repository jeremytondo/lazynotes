# Product Guidelines: LazyNotes

## Tone and Personality
- **Pragmatic and Minimalist:** The plugin should feel like a natural extension of LazyVim. Interactions and documentation should be direct, concise, and focused on immediate utility. Avoid unnecessary flourish.

## User Interface & Experience (UI/UX)
- **LazyVim Cohesion:** Always prefer standard Neovim UI abstractions (`vim.ui.input`, `vim.ui.select`). This ensures that the plugin inherits the user's configured UI enhancements (like `noice.nvim` or `dressing.nvim`) and feels consistent with the rest of the LazyVim ecosystem.
- **Keyboard-Centric Design:** Prioritize efficiency through commands and predictable keymapping support.
- **Non-Intrusive Feedback:** Use `vim.notify` sparingly. Only notify the user when an action is completed and requires their attention or when an error occurs. Assume a "silent success" model for background tasks like cache updates.

## Technical Principles
- **Modular Lua Architecture:**
    - Separate the "business logic" (tag parsing, file I/O, cache management) from the "plugin logic" (commands, autocompletion setup).
    - This separation facilitates easier testing and potential reuse.
- **Neovim Idioms:** Follow established community patterns for Neovim plugins:
    - Use a single entry point (e.g., `lua/lazynotes/init.lua`).
    - Expose a `setup()` function for configuration.
    - Avoid polluting the global namespace.
- **Documentation for Clarity:**
    - Documentation should explain *why* certain decisions were made, especially regarding integrations.
    - Keep comments in the code high-value and focused on complex logic.

## Integration Philosophy
- **Rely on the Best:** Don't reinvent features provided by `marksman` or `blink.cmp`. Instead, focus on providing the specific glue or metadata they need to enhance the markdown experience for LazyVim users.
