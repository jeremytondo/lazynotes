local format = require('lazynotes.format')

describe("Format Utility", function()
  describe("to_kebab_case", function()
    it("converts spaces to hyphens", function()
      assert.are.same("hello-world", format.to_kebab_case("Hello World"))
    end)

    it("converts to lowercase", function()
      assert.are.same("lowercase-string", format.to_kebab_case("Lowercase String"))
    end)

    it("handles multiple spaces", function()
      assert.are.same("multiple-spaces", format.to_kebab_case("Multiple   Spaces"))
    end)

    it("removes special characters", function()
      assert.are.same("special-chars", format.to_kebab_case("Special @#$ Chars!"))
    end)

    it("handles leading and trailing spaces", function()
      assert.are.same("trimmed-string", format.to_kebab_case("  Trimmed String  "))
    end)

    it("handles empty strings", function()
      assert.are.same("", format.to_kebab_case(""))
    end)
    
    it("handles nil input", function()
      assert.are.same("", format.to_kebab_case(nil))
    end)
  end)

  describe("to_title_case", function()
    it("converts lowercase to title case", function()
      assert.are.same("New Test Note", format.to_title_case("new test note"))
    end)

    it("handles already title cased strings", function()
      assert.are.same("Already Title Case", format.to_title_case("Already Title Case"))
    end)

    it("handles all caps", function()
      assert.are.same("All Caps", format.to_title_case("ALL CAPS"))
    end)

    it("handles mixed case", function()
      assert.are.same("Mixed Case", format.to_title_case("mIxEd CaSe"))
    end)

    it("handles multiple spaces", function()
      assert.are.same("Multiple Spaces", format.to_title_case("multiple   spaces"))
    end)

    it("handles nil and empty strings", function()
      assert.are.same("", format.to_title_case(""))
      assert.are.same("", format.to_title_case(nil))
    end)
  end)
end)
