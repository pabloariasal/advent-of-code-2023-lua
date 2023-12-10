local s = require('solution')
local lu = require('luaunit')
local util = require('util')
local inspect = require 'inspect'

function test_parsing()
    local input = [[
        Time:      7  15   30
        Distance:  9  40  200
    ]]
    local expected = {
        {time = 7, distance = 9},
        {time = 15, distance = 40},
        {time = 30, distance = 200},
    }
    local actual = s.parse_races(input)
    lu.assertEquals(expected, actual)
end

function test_flatten()
    local input = {
        {time = 7, distance = 9},
        {time = 15, distance = 40},
        {time = 30, distance = 200},
    }
    local actual = s.flatten(input)
    lu.assertEquals(actual, {time = 71530, distance = 940200})
end

function test_possible_wins_per_race()
    local wins = s.get_possible_wins_per_race({time = 7, distance = 9})
    lu.assertItemsEquals(wins, {2, 3, 4, 5})
    wins = s.get_possible_wins_per_race({time = 15, distance = 40})
    lu.assertEquals(#wins, 8)
    wins = s.get_possible_wins_per_race({time = 30, distance = 200})
    lu.assertEquals(#wins, 9)
end

os.exit( lu.LuaUnit.run() )
