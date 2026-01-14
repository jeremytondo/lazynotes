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
      -- Placeholder for next tasks
      print("Creating note: " .. input)
    end)
  end, {})
end

return M
