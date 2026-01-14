local Path = require('plenary.path')
local io_util = require('lazynotes.io')
local tags_util = require('lazynotes.tags')

describe("Tag Management - add_tag", function()
  local test_root
  
  before_each(function()
    test_root = Path:new(vim.fn.tempname())
    test_root:mkdir()
    io_util.init_project(test_root:absolute())
  end)

  after_each(function()
    if test_root and test_root:exists() then
      test_root:rmdir({ recursive = true })
    end
  end)

  it("adds a new tag to tags.json", function()
    local success = tags_util.add_tag("new-tag", test_root:absolute())
    assert.is_true(success)
    
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({ "new-tag" }, tags)
  end)

  it("does not add duplicate tags", function()
    tags_util.add_tag("tag1", test_root:absolute())
    local success = tags_util.add_tag("tag1", test_root:absolute())
    assert.is_true(success)
    
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({ "tag1" }, tags)
  end)

  it("initializes project if it doesn't exist when adding a tag", function()
    local fresh_root = Path:new(vim.fn.tempname())
    fresh_root:mkdir()
    -- No init_project call here
    
    local success = tags_util.add_tag("fresh", fresh_root:absolute())
    assert.is_true(success)
    
    local tags = io_util.read_tags(fresh_root:absolute())
    assert.are.same({ "fresh" }, tags)
    
    fresh_root:rmdir({ recursive = true })
  end)
end)

describe("Tag Management - sync_tags", function()
  local test_root
  
  before_each(function()
    test_root = Path:new(vim.fn.tempname())
    test_root:mkdir()
    io_util.init_project(test_root:absolute())
  end)

  after_each(function()
    if test_root and test_root:exists() then
      test_root:rmdir({ recursive = true })
    end
  end)

  it("scans markdown files and updates tags.json", function()
    local note1 = test_root:joinpath("note1.md")
    note1:write("---\ntags: [apple, banana]\n---\n", "w")
    
    local note2 = test_root:joinpath("note2.md")
    note2:write("---\ntags:\n  - cherry\n  - apple\n---\n", "w")
    
    local success = tags_util.sync_tags(test_root:absolute())
    assert.is_true(success)
    
    local tags = io_util.read_tags(test_root:absolute())
    table.sort(tags)
    assert.are.same({ "apple", "banana", "cherry" }, tags)
  end)

  it("handles empty project", function()
    local success = tags_util.sync_tags(test_root:absolute())
    assert.is_true(success)
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({}, tags)
  end)
end)
