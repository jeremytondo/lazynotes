local Path = require('plenary.path')
local io_util = require('lazynotes.io')

describe("IO Utility - Tag Formatting", function()
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

  it("writes tags.json in a pretty-printed format", function()
    local tags_to_write = { "tag1", "tag2" }
    local success = io_util.write_tags(test_root:absolute(), tags_to_write)
    assert.is_true(success)

    local tags_json = test_root:joinpath(".lazynotes", "tags.json")
    local content = tags_json:read()
    
    local expected_content = table.concat({
        "[",
        '  "tag1",',
        '  "tag2"',
        "]"
    }, "\n")
    
    assert.are.same(expected_content, content)
  end)
end)
