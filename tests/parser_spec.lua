local parser = require('lazynotes.parser')

describe("Parser - get_tags", function()
  it("extracts tags from list format", function()
    local content = [[
---
title: My Note
tags: [tag1, tag2, tag3]
---
Content here.
]]
    local tags = parser.get_tags(content)
    assert.are.same({ "tag1", "tag2", "tag3" }, tags)
  end)

  it("extracts tags with spaces from list format", function()
    local content = [[
---
tags: [tag one, tag two]
---
]]
    local tags = parser.get_tags(content)
    assert.are.same({ "tag one", "tag two" }, tags)
  end)

  it("extracts tags from bullet point format", function()
    local content = [[
---
tags:
  - apple
  - banana
---
]]
    local tags = parser.get_tags(content)
    assert.are.same({ "apple", "banana" }, tags)
  end)

  it("returns empty table if no tags found", function()
    local content = [[
---
title: No tags
---
]]
    local tags = parser.get_tags(content)
    assert.are.same({}, tags)
  end)

  it("handles malformed frontmatter gracefully", function()
    local content = "Not even markdown with frontmatter"
    local tags = parser.get_tags(content)
    assert.are.same({}, tags)
  end)

  it("extracts tags even if frontmatter is not at the very top (though it should be)", function()
    -- Some parsers are lenient. Let's see if we want to be.
    -- Usually it MUST be at the top.
  end)
end)
