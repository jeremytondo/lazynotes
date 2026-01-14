# Track Spec: Initial Project Setup

## Goal
Initialize the plugin repository with the correct directory structure, establish a functional test environment using `plenary.test` (Busted), and implement a basic "Hello World" command to verify that the plugin can be loaded and executed within Neovim.

## Core Requirements

### 1. Directory Structure
- Follow standard Neovim plugin layout:
    - `lua/lazynotes/init.lua`: Main entry point.
    - `tests/`: Directory for test files.

### 2. Plugin Initialization
- The `init.lua` must expose a `setup(opts)` function.
- `setup` should accept a configuration table (empty for now).

### 3. Test Environment
- Use `plenary.nvim` for testing.
- Create a `minimal_init.lua` to bootstrap the test environment (load `plenary` and the plugin itself).
- Create a test runner mechanism (e.g., a `Makefile` or shell script) that executes tests using `nvim --headless`.

### 4. Verification Command
- Implement a simple command, e.g., `:LazyNotesHealth` or just a log message upon setup, that confirms the plugin is active.
- For this track, a command `:LazyNotesHealth` that notifies "LazyNotes is active" is sufficient.

### 5. Testing
- A unit test must exist that requires `lazynotes` and calls `setup()`, asserting no errors occur.
- A unit test must verify that the verification command (or function) exists and runs.
