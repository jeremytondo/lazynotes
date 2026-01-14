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
end)
