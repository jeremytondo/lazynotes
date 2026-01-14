local lazynotes = require('lazynotes')

describe("lazynotes", function()
  it("setup can be called without errors", function()
    require("lazynotes").setup()
    assert.is_true(true)
  end)
end)
