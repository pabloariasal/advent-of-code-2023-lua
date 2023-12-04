local s = require('solution')
local lu = require('luaunit')

local testcases = {
    { input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53", expected = { id = 1, winnings = { 41, 48, 83, 86, 17 }, picks = { 83, 86, 6, 31, 17, 9, 48, 53 }, matches = { 48, 83, 17, 86 } } },
    { input = "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", expected = { id = 2, winnings = { 13, 32, 20, 16, 61 }, picks = { 61, 30, 68, 82, 17, 32, 24, 19 }, matches = { 32, 61 } } },
    { input = "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", expected = { id = 3, winnings = { 1, 21, 53, 59, 44 }, picks = { 69, 82, 63, 72, 16, 21, 14, 1 }, matches = { 1, 21 } } },
    { input = "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", expected = { id = 4, winnings = { 41, 92, 73, 84, 69 }, picks = { 59, 84, 76, 51, 58, 5, 54, 83 }, matches = { 84 } } },
    { input = "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", expected = { id = 5, winnings = { 87, 83, 26, 28, 32 }, picks = { 88, 30, 70, 12, 93, 22, 82, 36 }, matches = {} } },
    { input = "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11", expected = { id = 6, winnings = { 31, 18, 13, 56, 72 }, picks = { 74, 77, 10, 23, 35, 67, 36, 11 }, matches = {} } },
}

function test_parse_game()
    for _, v in ipairs(testcases) do
        local actual = s.parse_game(v.input)
        lu.assertEquals(actual.id, v.expected.id)
        lu.assertEquals(actual.winnings, v.expected.winnings)
        lu.assertEquals(actual.picks, v.expected.picks)
    end
end


function test_get_matches()
    for _, v in ipairs(testcases) do
        local actual = s.get_matches(s.parse_game(v.input))
        lu.assertItemsEquals(actual, v.expected.matches)
    end
end

os.exit( lu.LuaUnit.run() )
