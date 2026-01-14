local M = {}

function M.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_user_command("LazyNotesHealth", function()
    print("LazyNotes is active")
  end, {})
end

return M
