local lazynotes = require('lazynotes')

describe("lazynotes", function()
  it("setup can be called without errors", function()
    require("lazynotes").setup()
    assert.is_true(true)
  end)

  it("creates the LazyNotesHealth command after setup", function()
    require("lazynotes").setup()
    local exists = vim.fn.exists(":LazyNotesHealth")
    assert.is_equal(2, exists) -- 2 means command exists
  end)
end)
