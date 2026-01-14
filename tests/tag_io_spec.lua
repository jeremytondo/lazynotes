local Path = require('plenary.path')
local io_util = require('lazynotes.io')

describe("IO Utility - get_root", function()
  local test_root
  
  before_each(function()
    test_root = Path:new(vim.fn.tempname())
    test_root:mkdir()
  end)

  after_each(function()
    if test_root and test_root:exists() then
      test_root:rmdir({ recursive = true })
    end
  end)

  it("finds root via .lazynotes directory", function()
    local lazynotes_dir = test_root:joinpath(".lazynotes")
    lazynotes_dir:mkdir()
    
    local subdir = test_root:joinpath("sub", "deep")
    subdir:mkdir({ parents = true })
    
    local root = io_util.get_root(subdir:absolute())
    assert.are.same(test_root:absolute(), root)
  end)

  it("finds root via .git directory", function()
    local git_dir = test_root:joinpath(".git")
    git_dir:mkdir()
    
    local subdir = test_root:joinpath("sub")
    subdir:mkdir()
    
    local root = io_util.get_root(subdir:absolute())
    assert.are.same(test_root:absolute(), root)
  end)

  it("returns nil if no root found", function()
    local root = io_util.get_root(test_root:absolute())
    assert.is_nil(root)
  end)
end)

describe("IO Utility - init_project", function()
  local test_root
  
  before_each(function()
    test_root = Path:new(vim.fn.tempname())
    test_root:mkdir()
  end)

  after_each(function()
    if test_root and test_root:exists() then
      test_root:rmdir({ recursive = true })
    end
  end)

  it("creates .lazynotes directory and tags.json", function()
    local success = io_util.init_project(test_root:absolute())
    assert.is_true(success)
    
    local lazynotes_dir = test_root:joinpath(".lazynotes")
    local tags_json = lazynotes_dir:joinpath("tags.json")
    
    assert.is_true(lazynotes_dir:exists())
    assert.is_true(lazynotes_dir:is_dir())
    assert.is_true(tags_json:exists())
    assert.are.same("[]", tags_json:read())
  end)

  it("does not overwrite tags.json if it already exists", function()
    local lazynotes_dir = test_root:joinpath(".lazynotes")
    lazynotes_dir:mkdir()
    local tags_json = lazynotes_dir:joinpath("tags.json")
    tags_json:write('["existing"]', "w")
    
    local success = io_util.init_project(test_root:absolute())
    assert.is_true(success)
    assert.are.same('["existing"]', tags_json:read())
  end)
end)

describe("IO Utility - read/write tags", function()
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

  it("reads empty tags from a new project", function()
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({}, tags)
  end)

  it("writes and then reads tags", function()
    local tags_to_write = { "tag1", "tag2" }
    local success = io_util.write_tags(test_root:absolute(), tags_to_write)
    assert.is_true(success)
    
    local read_tags = io_util.read_tags(test_root:absolute())
    assert.are.same(tags_to_write, read_tags)
  end)

  it("handles malformed JSON in tags.json", function()
    local tags_json = test_root:joinpath(".lazynotes", "tags.json")
    tags_json:write('not json', "w")
    
    local tags = io_util.read_tags(test_root:absolute())
    assert.are.same({}, tags)
  end)
end)
