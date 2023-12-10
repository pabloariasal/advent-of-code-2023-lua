local util = require 'util'
local fun = require 'functional'
local inspect = require 'inspect'

local M = {}

local function numbers_it(str)
    return str:gmatch('%d+')
end

function M.parse_game(game_str)
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

function M.get_matches(game)
    assert(#game.picks >= #game.winnings, inspect(game))
    local matches = {}
    for i=1,#game.picks do
        if util.is_in_list(game.winnings, game.picks[i]) then
            table.insert(matches, game.picks[i])
        end
    end
    return matches
end

function M.part1(input_file)
    local sum = 0
    for l in io.lines(input_file) do
        local game = M.parse_game(l)
        local matches = M.get_matches(game)
        if #matches > 0 then
            sum = sum + 2^(#matches - 1)
        end
    end
    return math.floor(sum)
end


function M.part2(input_file)
    local all_cards = {}

    for l in io.lines(input_file) do
        local game = M.parse_game(l)
        table.insert(all_cards, { matches = #M.get_matches(game), copies = 1 })
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

M.solution_part1 = 24706
M.solution_part2 = 13114317

return M
