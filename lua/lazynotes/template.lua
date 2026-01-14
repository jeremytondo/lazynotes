local M = {}

function M.generate_note_content(title, date)
	date = date or os.date("%Y-%m-%d")

	return string.format(
		[[
---
date: %s
tags: []
---

# %s
]],
		date,
		title
	)
end

return M
