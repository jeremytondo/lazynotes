local Path = require('plenary.path')
local io_util = require('lazynotes.io')

describe("IO Utility", function()
  local test_file = "test-note.md"

  after_each(function()
    local path = Path:new(test_file)
    if path:exists() then
      path:rm()
    end
  end)

  it("writes content to a new file", function()
    local content = "test content"
    local success = io_util.write_note(test_file, content)

    assert.is_true(success)
    local path = Path:new(test_file)
    assert.is_true(path:exists())
    assert.are.same(content, path:read())
  end)

  it("fails if file already exists", function()
    -- Create the file first
    Path:new(test_file):write("existing", "w")

    local success = io_util.write_note(test_file, "new content")

    assert.is_false(success)
    assert.are.same("existing", Path:new(test_file):read())
  end)
end)
