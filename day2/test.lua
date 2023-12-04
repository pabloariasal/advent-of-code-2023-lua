local s = require('solution')
local lu = require('luaunit')

local testcases_part1 = {
    { input = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',                   expected = true },
    { input = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',         expected = true },
    { input = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red', expected = false },
    { input = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red', expected = false },
    { input = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',                   expected = true },
}

function test_is_game_possible()
    for _, v in ipairs(testcases_part1) do
        local game = s.parse_game(v.input)
        local actual = s.is_game_possible(game, s.configuration_part1)
        lu.assertEquals(actual, v.expected)
    end
end

-- Test Cases part 2
local testcases_part2 = {
    { input = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',                   expected = 48 },
    { input = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',         expected = 12 },
    { input = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red', expected = 1560 },
    { input = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red', expected = 630 },
    { input = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',                   expected = 36 },
}

function test_min_game_power()
    for _, v in ipairs(testcases_part2) do
        local game = s.parse_game(v.input)
        local actual = s.min_game_power(game)
        lu.assertEquals(actual, v.expected)
    end
end

os.exit( lu.LuaUnit.run() )
