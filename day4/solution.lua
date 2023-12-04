local util = require 'util'
local fun = require 'functional'

local function numbers_it(str)
    return str:gmatch('%d+')
end

local function parse_game(game_str)
    local game = {}
    local id = game_str:match('^Card%s+(%d+)')
    game.id = tonumber(id)

    local winning_substr = game_str:match(':%s([%d%s]+)%s|')
    game.winnings = util.insert_all_it({}, numbers_it(winning_substr))
    game.winnings = fun.map(game.winnings, tonumber)

    local picks_substr = game_str:match('|%s([%d%s]+)$')
    game.picks = util.insert_all_it({}, numbers_it(picks_substr))
    game.picks = fun.map(game.picks, tonumber)

    return game
end

local testcases = {
    { input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53", expected = { id = 1, winnings = { 41, 48, 83, 86, 17 }, picks = { 83, 86, 6, 31, 17, 9, 48, 53 }, matches = { 48, 83, 17, 86 } } },
    { input = "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", expected = { id = 2, winnings = { 13, 32, 20, 16, 61 }, picks = { 61, 30, 68, 82, 17, 32, 24, 19 }, matches = { 32, 61 } } },
    { input = "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", expected = { id = 3, winnings = { 1, 21, 53, 59, 44 }, picks = { 69, 82, 63, 72, 16, 21, 14, 1 }, matches = { 1, 21 } } },
    { input = "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", expected = { id = 4, winnings = { 41, 92, 73, 84, 69 }, picks = { 59, 84, 76, 51, 58, 5, 54, 83 }, matches = { 84 } } },
    { input = "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", expected = { id = 5, winnings = { 87, 83, 26, 28, 32 }, picks = { 88, 30, 70, 12, 93, 22, 82, 36 }, matches = {} } },
    { input = "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11", expected = { id = 6, winnings = { 31, 18, 13, 56, 72 }, picks = { 74, 77, 10, 23, 35, 67, 36, 11 }, matches = {} } },
}

local function test_parse_game()
    for _, v in ipairs(testcases) do
        local actual = parse_game(v.input)
        local desc = string.format("Input: %s, Expected: %s, Actual: %s", v.input, util.dump(v.expected),
            util.dump(actual))
        assert(actual.id == v.expected.id, desc)

        assert(#actual.winnings == #v.expected.winnings)
        for i, e in ipairs(v.expected.winnings) do
            assert(actual.winnings[i] == e, desc)
        end

        assert(#actual.picks == #v.expected.picks)
        for i, e in ipairs(v.expected.picks) do
            assert(actual.picks[i] == e, desc)
        end
    end
end

local function get_matches(game)
    assert(#game.picks >= #game.winnings, util.dump(game))
    local matches = {}
    for i=1,#game.picks do
        if util.is_in_list(game.winnings, game.picks[i]) then
            table.insert(matches, game.picks[i])
        end
    end
    return matches
end

local function test_get_matches()
    for _, v in ipairs(testcases) do
        local actual = get_matches(parse_game(v.input))
        local desc = string.format("Input: %s, Expected: %s, Actual: %s", v.input, util.dump(v.expected),
            util.dump(actual))
        assert(#actual, #v.expected.matches, desc)
        table.sort(actual)
        table.sort(v.expected.matches)
        for i, m in ipairs(v.expected.matches) do
            assert(actual[i] == m, desc)
        end
    end
end

test_parse_game()
test_get_matches()

local function part1()
    local sum = 0
    for l in io.lines(arg[1]) do
        local game = parse_game(l)
        local matches = get_matches(game)
        if #matches > 0 then
            sum = sum + 2^(#matches - 1)
        end
    end
    return math.floor(sum)
end

local p1 = part1()
print('Part 1: ' .. p1)
assert(p1 == 24706)

local function part2()
    local all_cards = {}

    for l in io.lines(arg[1]) do
        local game = parse_game(l)
        table.insert(all_cards, { matches = #get_matches(game), copies = 1 })
    end

    for i,c in ipairs(all_cards) do
        for j=1,c.copies do
            for k=1,c.matches do
                all_cards[i+k].copies = all_cards[i+k].copies + 1
            end
        end
    end

    return fun.reduce(all_cards, function(acc, c) return acc + c.copies end, 0)
end

local p2 = part2()
print('Part 2: ' .. p2)
assert(p2 == 13114317)
