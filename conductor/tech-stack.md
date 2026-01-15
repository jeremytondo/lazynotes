# Tech Stack: LazyNotes

## Core Languages & Runtimes
- **Lua:** The primary language for all plugin logic, leveraging Neovim's embedded LuaJIT.
- **Neovim:** Minimum version **>= 0.11.2** (aligned with current LazyVim requirements).

## Neovim API & Libraries
- **Standard Neovim API (`vim.*`):** Used for command registration, UI interactions (`vim.ui.input`, `vim.ui.select`), and core editor functionality.
- **Plenary.nvim:** Utilized for utility functions (path management, async operations) and as the foundation for the testing framework.
- **LazyVim Components:** Integration with built-in LazyVim modules for consistent input handling, notifications (`vim.notify`), and UI consistency.
- **JSON Storage:** Uses Neovim's built-in `vim.json` for tag persistence and project-local configuration.

## Required Dependencies (Integrations)
- **blink.cmp:** Essential for providing the tag autocompletion and fuzzy finding experience.
- **Marksman (LSP):** Leveraged for core markdown intelligence, ensuring LazyNotes complements existing LSP features.

## Tooling & Development
- **Testing:** `plenary.test` (Busted) will be the primary framework for unit and integration testing, leveraging the `plenary.nvim` infrastructure.
- **Package Management:** Designed to be installed via `lazy.nvim`, following standard Neovim plugin distribution patterns.
