local M = {}

function M.to_kebab_case(str)
	if not str then
		return ""
	end

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

function M.to_title_case(str)
	if not str or str == "" then
		return ""
	end

	-- Replace multiple spaces with single space and trim
	str = str:gsub("%s+", " "):match("^%s*(.-)%s*$")

	-- Capitalize first letter of each word
	return (str:gsub("(%a)([%w]*)", function(first, rest)
		return first:upper() .. rest:lower()
	end))
end

return M
