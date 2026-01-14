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

  it("creates a note and opens it (simulated flow)", function()
    local Path = require('plenary.path')
    local test_title = "integration test note"
    local expected_file = "integration-test-note.md"
    
    -- Cleanup if exists
    Path:new(expected_file):rm()

    -- We can't easily test vim.ui.input headlessly with plenary.busted 
    -- but we can test the internal logic if we refactor it, or just 
    -- verify the end state by calling the command if we could mock the input.
    -- For now, let's ensure the modules work together.
    
    local format = require('lazynotes.format')
    local template = require('lazynotes.template')
    local io_util = require('lazynotes.io')

    local filename = format.to_kebab_case(test_title) .. ".md"
    local title_case_title = format.to_title_case(test_title)
    local content = template.generate_note_content(title_case_title)

    assert.is_true(io_util.write_note(filename, content))
    assert.is_true(Path:new(filename):exists())
    
    -- Verify content is Title Case
    local actual_content = Path:new(filename):read()
    assert.truthy(actual_content:match("# Integration Test Note"))
    
    -- Cleanup
    Path:new(filename):rm()
  end)
end)
