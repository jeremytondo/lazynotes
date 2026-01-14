local M = {}

function M.to_kebab_case(str)
  if not str then return "" end
  
  -- content to lowercase
  str = str:lower()
  -- replace non-alphanumeric characters with spaces
  str = str:gsub("[^a-z0-9]", " ")
  -- trim whitespace
  str = str:match("^%s*(.-)%s*$")
  -- replace spaces with hyphens
  str = str:gsub("%s+", "-")
  
  return str
end

return M
