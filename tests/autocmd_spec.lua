local Path = require('plenary.path')
local io_util = require('lazynotes.io')
local lazynotes = require('lazynotes')
local spy = require('luassert.spy')

describe("Autocmds", function()
  local test_root

  before_each(function()
    test_root = Path:new(vim.fn.tempname())
    test_root:mkdir()
    -- Initialize lazynotes project structure
    io_util.init_project(test_root:absolute())
    
    -- Setup lazynotes to register autocmds
    lazynotes.setup()
  end)

  after_each(function()
    if test_root and test_root:exists() then
      test_root:rmdir({ recursive = true })
    end
  end)

  it("updates tags.json on save when file has tags", function()
    local note_path = test_root:joinpath("note_with_tags.md")
    
    vim.cmd("edit " .. note_path:absolute())
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "---",
        "tags: [foo]",
        "---",
        "# content"
    })
    
    -- Trigger write
    vim.cmd("write")
    
    -- Check tags.json
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({ "foo" }, tags)
  end)

  it("does NOT call update_tags on save when file has NO tags", function()
    local note_path = test_root:joinpath("note_no_tags.md")
    
    local tags_mod = require("lazynotes.tags")
    local s = spy.on(tags_mod, "update_tags")
    
    vim.cmd("edit " .. note_path:absolute())
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "---",
        "title: No Tags",
        "---",
        "# content"
    })
    
    vim.cmd("write")
    
    assert.spy(s).was_not_called()
    s:revert()
  end)
  
   it("does NOT call update_tags on save when file has EMPTY tags", function()
    local note_path = test_root:joinpath("note_empty_tags.md")
    
    local tags_mod = require("lazynotes.tags")
    local s = spy.on(tags_mod, "update_tags")
    
    vim.cmd("edit " .. note_path:absolute())
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "---",
        "tags: []",
        "---",
        "# content"
    })
    
    vim.cmd("write")
    
    assert.spy(s).was_not_called()
    s:revert()
  end)
end)
