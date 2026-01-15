local M = {}

local io = require('lazynotes.io')

local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

function M:get_trigger_characters()
  -- Tags in frontmatter are usually in [tag, tag] or list format.
  -- We'll trigger on any character if we are in the right context.
  return { " ", ",", "[" }
end

local function is_in_tags_context()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- 1. Simple check: is the current line part of the frontmatter?
  -- Frontmatter is between --- and --- at the top of the file.
  local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
  local in_frontmatter = false
  local dash_count = 0
  for _, l in ipairs(lines) do
    if l:match("^%-%-%-") then
      dash_count = dash_count + 1
    end
  end

  if dash_count ~= 1 then
    return false
  end

  -- 2. Is the line the 'tags' line or a bullet point under 'tags'?
  if line:match("^tags:%s*%[") or line:match("^%s*-%s*") then
    -- Check if we are actually under the 'tags:' key in the frontmatter
    -- This is a bit simplified, but good for a start.
    return true
  end

  return false
end

function M:get_completions(context, callback)
  if not is_in_tags_context() then
    callback({ items = {} })
    return
  end

  local root = io.get_root(vim.fn.expand("%:p:h"))
  if not root then
    callback({ items = {} })
    return
  end

  local tags = io.read_tags(root)
  local items = {}
  for _, tag in ipairs(tags) do
    table.insert(items, {
      label = tag,
      kind = vim.lsp.protocol.CompletionItemKind.Keyword,
      documentation = "LazyNotes tag"
    })
  end

  callback({
    items = items
  })
end

return M
