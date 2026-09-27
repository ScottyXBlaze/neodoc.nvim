local template = require("neodoc.templates.google")
local test = require("plenary.busted")

describe("Google Template", function()
    it("should generate a valid docstring", function()
        local func_data = { name = "my_function", params = "x, y" }
        local docstring = template.generate(func_data)
        assert.is_true(docstring:match("Args:"))
    end)

    describe("Generic type hints", function()
        it("should preserve nested generic types for every template style", function()
            for _, style in ipairs({ "google", "numpy", "sphinx" }) do
                local template = require("neodoc.templates." .. style)
                local docstring = template.generate({
                    name = "hello",
                    params = "pos: tuple[int, int]",
                })

                assert.is_true(docstring:match("tuple%[int, int%]"))
                assert.is_nil(docstring:match("\n%s*int"))
            end
        end)
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

    it("should preserve nested generic types with spaces", function()
        local func_data = {
            name = "hello",
            params = "pos: tuple[int, int]",
        }
        local docstring = template.generate(func_data)

        assert.is_true(docstring:match("pos %(tuple%[int, int%]%)"))
        assert.is_nil(docstring:match("\n    int %("))
    end)
end)
