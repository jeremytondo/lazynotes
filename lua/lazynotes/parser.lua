local M = {}

function M.get_tags(content)
	if not content then
		return {}
	end

	-- Extract frontmatter (between --- and ---)
	local frontmatter = content:match("^%-%-%-\n(.-)\n%-%-%-")
	if not frontmatter then
		return {}
	end

	local tags = {}
	-- Try to find tags: [tag1, tag2]
	local list_match = frontmatter:match("tags:%s*%[(.-)%]")
	if list_match then
		for tag in list_match:gmatch("([^,%s]+)") do
			table.insert(tags, tag)
		end
		return tags
	end

	-- Try to find tags: followed by bullets
	local bullet_match = frontmatter:match("tags:%s*\n(.-)(\n[%w])") or frontmatter:match("tags:%s*\n(.-)$")
	if bullet_match then
		for tag in bullet_match:gmatch("%s*-%s*([%w%-_]+)") do
			table.insert(tags, tag)
		end
	end

	return tags
end

return M
