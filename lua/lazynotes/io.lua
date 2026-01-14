local Path = require('plenary.path')
local M = {}

function M.write_note(filename, content)
  local path = Path:new(filename)
  
  if path:exists() then
    vim.notify("LazyNotes: File already exists: " .. filename, vim.log.levels.ERROR)
    return false
  end
  
  path:write(content, "w")
  return true
end

return M
