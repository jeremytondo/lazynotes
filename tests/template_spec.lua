local template = require('lazynotes.template')

describe("Template Generator", function()
  describe("generate_note_content", function()
    it("generates correct markdown with date and title", function()
      local title = "My Note Title"
      local date = "2026-01-14"

      local expected = [[
---
date: 2026-01-14
tags: []
---

# My Note Title
]]

      -- We pass the date explicitly for testing
      assert.are.same(expected, template.generate_note_content(title, date))
    end)

    it("uses current date if none provided", function()
      local title = "Today Note"
      local content = template.generate_note_content(title)
      local date_pattern = os.date("%Y-%m-%d")

      assert.truthy(content:find("date: " .. date_pattern, 1, true))
    end)

    it("handles empty title", function()
       local expected = [[
---
date: 2026-01-14
tags: []
---

# 
]]
      assert.are.same(expected, template.generate_note_content("", "2026-01-14"))
    end)
  end)
end)
