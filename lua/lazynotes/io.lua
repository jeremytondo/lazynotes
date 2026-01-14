local Path = require("plenary.path")
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

function M.get_root(start_path)
	local path = Path:new(start_path or vim.fn.getcwd())

	for _, p in ipairs(path:parents()) do
		local parent_path = Path:new(p)
		local lazynotes = parent_path:joinpath(".lazynotes")
		if lazynotes:exists() and lazynotes:is_dir() then
			return parent_path:absolute()
		end

		local git = parent_path:joinpath(".git")
		if git:exists() and git:is_dir() then
			return parent_path:absolute()
		end
	end

	-- Check the path itself
	local lazynotes = path:joinpath(".lazynotes")
	if lazynotes:exists() and lazynotes:is_dir() then
		return path:absolute()
	end

	local git = path:joinpath(".git")
	if git:exists() and git:is_dir() then
		return path:absolute()
	end

	return nil
end

function M.init_project(root)
	if not root then
		return false
	end

	local lazynotes_dir = Path:new(root):joinpath(".lazynotes")
	if not lazynotes_dir:exists() then
		lazynotes_dir:mkdir()
	end

	local tags_json = lazynotes_dir:joinpath("tags.json")
	if not tags_json:exists() then
		tags_json:write("[]", "w")
	end

	return true
end

function M.read_tags(root)
	if not root then
		return {}
	end

	local tags_json = Path:new(root):joinpath(".lazynotes", "tags.json")
	if not tags_json:exists() then
		return {}
	end

	local content = tags_json:read()
	if not content or content == "" then
		return {}
	end

	local ok, tags = pcall(vim.json.decode, content)
	if not ok or type(tags) ~= "table" then
		return {}
	end

	return tags
end

function M.write_tags(root, tags)
	if not root then
		return false
	end

	local lazynotes_dir = Path:new(root):joinpath(".lazynotes")
	if not lazynotes_dir:exists() then
		lazynotes_dir:mkdir()
	end

	local tags_json = lazynotes_dir:joinpath("tags.json")
	local ok, content = pcall(vim.json.encode, tags)
	if not ok then
		vim.notify("LazyNotes: Failed to encode tags to JSON", vim.log.levels.ERROR)
		return false
	end

	-- Ensure empty table is written as [] instead of {} if possible
	if #tags == 0 then
		content = "[]"
	end

	tags_json:write(content, "w")
	return true
end

return M
