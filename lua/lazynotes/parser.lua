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
		for tag in list_match:gmatch("([^,]+)") do
			-- trim whitespace
			tag = tag:match("^%s*(.-)%s*$")
			if tag and tag ~= "" then
				table.insert(tags, tag)
			end
		end
		return tags
	end

	-- Try to find tags: followed by bullets
	-- Capture everything from "tags:\n" until the next section (--- or key:)
	-- But simplistic approach: capture until end of block
	local bullet_block = frontmatter:match("tags:%s*\n(.-)\n[a-z]") or frontmatter:match("tags:%s*\n(.-)$")

	if bullet_block then
		for line in bullet_block:gmatch("[^\r\n]+") do
			local tag = line:match("^%s*-%s*(.-)%s*$")
			if tag and tag ~= "" then
				table.insert(tags, tag)
			end
		end
	end

	return tags
end

return M
