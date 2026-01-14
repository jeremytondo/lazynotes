local M = {}

local defaults = {
  keys = {
    create_note = "<leader>zn",
  },
}

function M.setup(opts)
  if opts == nil then
    opts = defaults
  elseif opts.keys == false then
    opts = vim.tbl_deep_extend("force", defaults, opts)
    opts.keys = false
  else
    opts = vim.tbl_deep_extend("force", defaults, opts)
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

  if opts.keys ~= false then
    if opts.keys.create_note then
      vim.keymap.set("n", opts.keys.create_note, ":LazyNotesCreate<CR>", { silent = true, desc = "Create new note" })
    end
  end
end

return M
