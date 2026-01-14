local M = {}

function M.setup(opts)
  opts = opts or {}
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
      local content = template.generate_note_content(input)

      if io.write_note(filename, content) then
        vim.cmd.edit(filename)
        -- Position cursor at the end of the file
        local last_line = vim.api.nvim_buf_line_count(0)
        vim.api.nvim_win_set_cursor(0, { last_line, 0 })
      end
    end)
  end, {})
end

return M
