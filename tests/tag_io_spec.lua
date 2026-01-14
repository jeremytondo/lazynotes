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
