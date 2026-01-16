local Path = require('plenary.path')
local io_util = require('lazynotes.io')
local tags_util = require('lazynotes.tags')

describe("Incremental Tag Updates", function()
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

  it("adds new tags from a list to tags.json", function()
    -- Initial state: tags.json has "existing"
    local tags_json = test_root:joinpath(".lazynotes", "tags.json")
    tags_json:write('["existing"]', "w")

    -- Call update_tags with new tags
    local new_tags = {"new-one", "another-one"}
    tags_util.update_tags(new_tags, test_root:absolute())

    local tags = io_util.read_tags(test_root:absolute())
    table.sort(tags)
    assert.are.same({ "another-one", "existing", "new-one" }, tags)
  end)

  it("does not duplicate existing tags", function()
    local tags_json = test_root:joinpath(".lazynotes", "tags.json")
    tags_json:write('["existing"]', "w")

    local new_tags = {"existing", "new-one"}
    tags_util.update_tags(new_tags, test_root:absolute())

    local tags = io_util.read_tags(test_root:absolute())
    table.sort(tags)
    assert.are.same({ "existing", "new-one" }, tags)
  end)
  
  it("normalizes tags before adding", function()
     local tags_json = test_root:joinpath(".lazynotes", "tags.json")
    tags_json:write('[]', "w")

    local new_tags = {"My Tag"}
    tags_util.update_tags(new_tags, test_root:absolute())

    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({ "my-tag" }, tags)
  end)
end)
