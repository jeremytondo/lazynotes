local tags = require('lazynotes.tags')
local match = require("luassert.match")

describe("Tag Normalization", function()
  it("normalizes inline list tags in a buffer", function()
    local content = {
      "---",
      "title: Test Note",
      "tags: [machine learning, data science]",
      "---",
      "Content"
    }
    
    -- Create a temporary buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    -- Normalize tags
    tags.normalize_buffer_tags(buf)
    
    -- Verify content
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local tags_line = lines[3] -- 1-based in file, 3rd line (index 3 in table)
    
    assert.are.same("tags: [machine-learning, data-science]", tags_line)
  end)

  it("normalizes bullet list tags in a buffer", function()
    local content = {
      "---",
      "tags:",
      "  - machine learning",
      "  - data science",
      "---",
      "Content"
    }
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    tags.normalize_buffer_tags(buf)
    
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    assert.are.same("  - machine-learning", lines[3])
    assert.are.same("  - data-science", lines[4])
  end)

  it("preserves other frontmatter keys", function()
    local content = {
      "---",
      "title: Keep Me",
      "tags: [Tag One]",
      "date: 2024-01-01",
      "---"
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    tags.normalize_buffer_tags(buf)
    
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    assert.are.same("title: Keep Me", lines[2])
    assert.are.same("tags: [tag-one]", lines[3])
    assert.are.same("date: 2024-01-01", lines[4])
  end)

  it("handles special characters in tags", function()
    local content = {
      "---",
      "tags: [Hello World!, #Special@Tag]",
      "---"
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    tags.normalize_buffer_tags(buf)
    
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    assert.are.same("tags: [hello-world, special-tag]", lines[2])
  end)
end)
