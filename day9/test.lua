local s = require('solution')
local lu = require('luaunit')
local util = require('util')
local inspect = require 'inspect'

function test_grow()
    local input = { 0, 3, 6, 9, 12, 15 }
    local expected = {
        { 0, 3, 6, 9, 12, 15 },
        { 3, 3, 3, 3, 3 },
        { 0, 0, 0, 0 },
    }
    local actual = s.grow(input)
    lu.assertEquals(actual, expected)
end

function test_interpolate_value()
    local input = {
        { 0, 3, 6, 9, 12, 15 },
        { 3, 3, 3, 3, 3 },
        { 0, 0, 0, 0 },
    }
    local actual = s.interpolate_new_value(input)
    lu.assertEquals(actual, 18)
end

function test_extrapolate_backwards()
    local input = {
        { 10, 13, 16, 21, 30, 45, },
        { 3,  3,  5,  9,  15, },
        { 0,  2,  4,  6, },
        { 2,  2,  2, },
        { 0,  0, } }
    local actual = s.extrapolate_backwards(input)
    lu.assertEquals(actual, 5)
end

os.exit(lu.LuaUnit.run())
