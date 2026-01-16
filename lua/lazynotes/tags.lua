local io = require("lazynotes.io")
local parser = require("lazynotes.parser")
local format = require("lazynotes.format")
local Path = require("plenary.path")
local scan = require("plenary.scandir")
local M = {}

function M.add_tag(tag, root)
	root = root or io.get_root()
	if not root then
		vim.notify(
			"LazyNotes: Could not find project root. Are you in a git repo or have a .lazynotes folder?",
			vim.log.levels.ERROR
		)
		return false
	end

	io.init_project(root)

	-- Normalize tag
	tag = format.to_kebab_case(tag)

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

function M.update_tags(new_tags, root)
	root = root or io.get_root()
	if not root then
		return false
	end

	io.init_project(root)

	local current_tags = io.read_tags(root)
	local tag_map = {}
	for _, t in ipairs(current_tags) do
		tag_map[t] = true
	end

	local modified = false
	for _, tag in ipairs(new_tags) do
		local normalized = format.to_kebab_case(tag)
		if normalized ~= "" and not tag_map[normalized] then
			table.insert(current_tags, normalized)
			tag_map[normalized] = true
			modified = true
		end
	end

	if modified then
		table.sort(current_tags)
		return io.write_tags(root, current_tags)
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

	-- Determine configuration
	local global_config = require("lazynotes").config or {}
	local project_config = io.read_config(root)

	-- Default true, override with global, then override with project
	local respect_gitignore = true
	if global_config.tag_sync and global_config.tag_sync.respect_gitignore ~= nil then
		respect_gitignore = global_config.tag_sync.respect_gitignore
	end
	if project_config.tag_sync and project_config.tag_sync.respect_gitignore ~= nil then
		respect_gitignore = project_config.tag_sync.respect_gitignore
	end

	local files = scan.scan_dir(root, {
		search_pattern = "%.md$",
		respect_gitignore = respect_gitignore,
		hidden = false,
	})

	local all_tags = {}
	local tag_map = {}

	for _, file in ipairs(files) do
		local path = Path:new(file)
		local content = path:read()
		local tags = parser.get_tags(content)
		for _, tag in ipairs(tags) do
			tag = format.to_kebab_case(tag)
			if not tag_map[tag] and tag ~= "" then
				tag_map[tag] = true
				table.insert(all_tags, tag)
			end
		end
	end

	-- Merge with existing tags
	local existing_tags = io.read_tags(root)
	for _, tag in ipairs(existing_tags) do
		-- assuming existing tags are already normalized, but let's be safe
		tag = format.to_kebab_case(tag)
		if not tag_map[tag] and tag ~= "" then
			tag_map[tag] = true
			table.insert(all_tags, tag)
		end
	end

	table.sort(all_tags)

	return io.write_tags(root, all_tags)
end

function M.normalize_buffer_tags(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local in_frontmatter = false
	local in_tags_block = false
	local modified = false

	for i, line in ipairs(lines) do
		-- Check frontmatter boundaries
		if line:match("^%-%-%-") then
			if i == 1 then
				in_frontmatter = true
			elseif in_frontmatter then
				-- End of frontmatter
				break
			end
			goto continue
		end

		if in_frontmatter then
			-- Case 1: Inline list tags: [tag one, tag two]
			if line:match("^tags:%s*%[") then
				local prefix, list_content, suffix = line:match("^(tags:%s*%[)(.-)(%].*)$")
				if list_content then
					local tags = {}
					for tag in list_content:gmatch("([^,]+)") do
						table.insert(tags, format.to_kebab_case(tag))
					end
					local new_line = prefix .. table.concat(tags, ", ") .. suffix
					if new_line ~= line then
						lines[i] = new_line
						modified = true
					end
				end
				in_tags_block = false

			-- Case 2: Start of tags block (tags:)
			elseif line:match("^tags:%s*$") then
				in_tags_block = true

			-- Case 3: Bullet points inside tags block
			elseif in_tags_block and line:match("^%s*-%s*") then
				local indent, tag_content = line:match("^(%s*-%s*)(.*)$")
				if tag_content then
					local new_tag = format.to_kebab_case(tag_content)
					local new_line = indent .. new_tag
					if new_line ~= line then
						lines[i] = new_line
						modified = true
					end
				end

			-- Case 4: Any other key resets tags block context
			elseif line:match("^[a-z].-:") then
				in_tags_block = false
			end
		end

		::continue::
	end

	if modified then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	end
end

return M
