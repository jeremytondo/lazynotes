local M = {}

local defaults = {
  keys = {
    create_note = "<leader>zn",
  },
  tag_sync = {
    respect_gitignore = true,
  },
  blink_cmp_source = "lazynotes",
}

M.config = vim.deepcopy(defaults)

function M.setup(opts)
  if opts == nil then
    opts = {}
  end

  -- Reset config to defaults to ensure clean state for each setup call (useful for tests)
  M.config = vim.deepcopy(defaults)

  -- Handle keys option separately if it's explicitly false
  local keys_disabled = (opts.keys == false)

  M.config = vim.tbl_deep_extend("force", M.config, opts)

  if keys_disabled then
    M.config.keys = false
  end

  -- Check if keys is nil (shouldn't happen with deep_extend unless passed as nil explicitly which deep_extend ignores, or if defaults were overwritten)
  -- But let's be safe.
  if M.config.keys == nil then
      M.config.keys = { create_note = "<leader>zn" }
  end

  vim.api.nvim_create_user_command("LazyNotesHealth", function()
    print("LazyNotes is active")
  end, {})

  vim.api.nvim_create_user_command("LazyNotesCreate", function()
    vim.ui.input({ prompt = "Note Title: " }, function(input)
      if not input or input == "" then
        return
      end

      local format = require("lazynotes.format")
      local template = require("lazynotes.template")
      local io = require("lazynotes.io")

      local filename = format.to_kebab_case(input) .. ".md"
      local title_case_input = format.to_title_case(input)
      local content = template.generate_note_content(title_case_input)

      if io.write_note(filename, content) then
        vim.cmd.edit(filename)
        -- Position cursor at the end of the file
        local last_line = vim.api.nvim_buf_line_count(0)
        vim.api.nvim_win_set_cursor(0, { last_line, 0 })
      end
    end)
  end, {})

  vim.api.nvim_create_user_command("LazyNotesAddTag", function()
    vim.ui.input({ prompt = "Add Tag: " }, function(input)
      if not input or input == "" then
        return
      end

      local tags = require("lazynotes.tags")
      -- Pass current buffer's directory to help find root
      local root = require("lazynotes.io").get_root(vim.fn.expand("%:p:h"))

      if tags.add_tag(input, root) then
        vim.notify("LazyNotes: Added tag '" .. input .. "'", vim.log.levels.INFO)
      end
    end)
  end, {})

  vim.api.nvim_create_user_command("LazyNotesSyncTags", function()
    local tags = require("lazynotes.tags")
    local root = require("lazynotes.io").get_root(vim.fn.expand("%:p:h"))
    if tags.sync_tags(root) then
      vim.notify("LazyNotes: Tags synchronized", vim.log.levels.INFO)
    end
  end, {})

  -- Auto-update tags on save
  local augroup = vim.api.nvim_create_augroup("LazyNotesAutoSync", { clear = true })
  
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.md",
    callback = function()
      local tags = require("lazynotes.tags")
      local io = require("lazynotes.io")
      local root = io.get_root(vim.fn.expand("%:p:h"))
      if root then
        tags.normalize_buffer_tags(0)
      end
    end,
    group = augroup,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.md",
    callback = function()
      local tags = require("lazynotes.tags")
      local io = require("lazynotes.io")
      local parser = require("lazynotes.parser")
      local root = io.get_root(vim.fn.expand("%:p:h"))

      if root then
        local bufnr = vim.api.nvim_get_current_buf()
        local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
        local file_tags = parser.get_tags(content)

        if #file_tags > 0 then
          tags.update_tags(file_tags, root)
        end
      end
    end,
    group = augroup,
  })

  if M.config.keys ~= false then
    if M.config.keys.create_note then
      vim.keymap.set("n", M.config.keys.create_note, ":LazyNotesCreate<CR>", { silent = true, desc = "Create new note" })
    end

    local has_wk, wk = pcall(require, "which-key")
    if has_wk then
      wk.add({
        { "<leader>z", group = "LazyNotes" },
      })
    end
  end
end

return M
