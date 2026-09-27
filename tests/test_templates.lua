local template = require("neodoc.templates.google")
local test = require("plenary.busted")

describe("Google Template", function()
    it("should generate a valid docstring", function()
        local func_data = { name = "my_function", params = "x, y" }
        local docstring = template.generate(func_data)
        assert.is_true(docstring:match("Args:"))
    end)

    it("should preserve commas inside generic parameter types", function()
        local func_data = {
            name = "my_function",
            params = "values: tuple[int, int], name: str",
        }
        local docstring = template.generate(func_data)

        assert.is_true(docstring:match("values %(tuple%[int, int%]%)"))
        assert.is_true(docstring:match("name %(str%)"))
    end)
end)
