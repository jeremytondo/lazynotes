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

return M
