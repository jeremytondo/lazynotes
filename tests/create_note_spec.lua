local lazynotes = require('lazynotes')

describe("LazyNotesCreate command", function()
  before_each(function()
    -- Reset commands before each test if possible, or just call setup
    require("lazynotes").setup()
  end)

  it("registers the LazyNotesCreate command", function()
    local exists = vim.fn.exists(":LazyNotesCreate")
    assert.is_equal(2, exists)
  end)
end)
