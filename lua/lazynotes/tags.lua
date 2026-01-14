local io = require('lazynotes.io')
local M = {}

function M.add_tag(tag, root)
	root = root or io.get_root()
	if not root then
		vim.notify("LazyNotes: Could not find project root. Are you in a git repo or have a .lazynotes folder?", vim.log.levels.ERROR)
		return false
	end

	io.init_project(root)
	local tags = io.read_tags(root)

	local exists = false
	for _, t in ipairs(tags) do
		if t == tag then
			exists = true
			break
		end
	end

	if not exists then
		table.insert(tags, tag)
		return io.write_tags(root, tags)
	end

	return true
end

return M
