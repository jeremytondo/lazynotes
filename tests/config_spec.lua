local lazynotes = require('lazynotes')

describe("lazynotes.config", function()
  before_each(function()
    -- Clear mappings before each test
    pcall(vim.keymap.del, "n", "<leader>zn")
    pcall(vim.keymap.del, "n", "<leader>nn")
  end)

  it("sets default keybinding <leader>zn after setup", function()
    lazynotes.setup()
    local rhs = vim.fn.maparg("<leader>zn", "n", false, false)
    assert.is_equal(":LazyNotesCreate<CR>", rhs)
  end)

  it("sets custom keybinding if provided in opts", function()
    lazynotes.setup({ keys = { create_note = "<leader>nn" } })
    local rhs = vim.fn.maparg("<leader>nn", "n", false, false)
    assert.is_equal(":LazyNotesCreate<CR>", rhs)

    local default_rhs = vim.fn.maparg("<leader>zn", "n", false, false)
    assert.is_equal("", default_rhs)
  end)

  it("disables keybindings if keys = false", function()
    lazynotes.setup({ keys = false })
    local rhs = vim.fn.maparg("<leader>zn", "n", false, false)
    assert.is_equal("", rhs)
  end)

  it("registers which-key group if which-key is available", function()
    -- Mock which-key
    package.loaded["which-key"] = {
      add = function(mappings)
        _G.wk_mappings = mappings
      end
    }

    lazynotes.setup()

    assert.is_not_nil(_G.wk_mappings)
    -- Check if it registered <leader>z
    local found = false
    for _, m in ipairs(_G.wk_mappings) do
      if m[1] == "<leader>z" and m.group == "LazyNotes" then
        found = true
        break
      end
    end
    assert.is_true(found)

    -- Cleanup mock
    package.loaded["which-key"] = nil
    _G.wk_mappings = nil
  end)
end)
