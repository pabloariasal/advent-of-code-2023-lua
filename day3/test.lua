local s = require('solution')
local lu = require('luaunit')
local util = require('util')

function test_is_digit()
    local testcases = {
        { input = '+', expected = false },
        { input = '#', expected = false },
        { input = '*', expected = false },
        { input = '5', expected = true },
        { input = '.', expected = false },
    }
    for _, v in ipairs(testcases) do
        local actual = s.isDigit(v.input)
        lu.assertEquals(actual, v.expected, util.dump(v))
    end
end

function test_is_point()
    local testcases = {
        { input = '+', expected = false },
        { input = '#', expected = false },
        { input = '*', expected = false },
        { input = '5', expected = false },
        { input = '.', expected = true },
    }
    for _, v in ipairs(testcases) do
        local actual = s.isPoint(v.input)
        lu.assertEquals(actual, v.expected, util.dump(v))
    end
end

function test_is_symbol()
    local testcases = {
        { input = '+', expected = true },
        { input = '#', expected = true },
        { input = '*', expected = true },
        { input = '$', expected = true },
        { input = '5', expected = false },
        { input = '.', expected = false },
    }
    for _, v in ipairs(testcases) do
        local actual = s.isSymbol(v.input)
        lu.assertEquals(actual, v.expected, util.dump(v))
    end
end



os.exit( lu.LuaUnit.run() )
