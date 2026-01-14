local io = require('lazynotes.io')
local parser = require('lazynotes.parser')
local Path = require('plenary.path')
local scan = require('plenary.scandir')
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

function M.sync_tags(root)
	root = root or io.get_root()
	if not root then
		vim.notify("LazyNotes: Could not find project root.", vim.log.levels.ERROR)
		return false
	end

	io.init_project(root)

	local files = scan.scan_dir(root, {
		search_pattern = "%.md$",
		respect_gitignore = true,
		hidden = false,
	})

	local all_tags = {}
	local tag_map = {}

	for _, file in ipairs(files) do
		local path = Path:new(file)
		local content = path:read()
		local tags = parser.get_tags(content)
		for _, tag in ipairs(tags) do
			if not tag_map[tag] then
				tag_map[tag] = true
				table.insert(all_tags, tag)
			end
		end
	end

	-- Merge with existing tags in case some were manually added or deleted?
	-- The spec says: "update tags.json to include any missing ones"
	local existing_tags = io.read_tags(root)
	for _, tag in ipairs(existing_tags) do
		if not tag_map[tag] then
			tag_map[tag] = true
			table.insert(all_tags, tag)
		end
	end

	return io.write_tags(root, all_tags)
end

return M
