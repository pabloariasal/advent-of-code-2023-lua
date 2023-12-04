local st = require 'string-utils'
local util = require 'util'
local fun = require 'functional'

local M = {}

function M.parse_game(game_str)
    local game_id_pattern = '^Game (%d+):'
    local game = {}
    game.id = string.match(game_str, game_id_pattern)
    game.subsets = {}
    for _, subset in ipairs(st.split_string(game_str, ';')) do
        local s = {}
        local blue = string.match(subset, '(%d+) blue')
        if blue then
            s.blue = tonumber(blue)
        end
        local red = string.match(subset, '(%d+) red')
        if red then
            s.red = tonumber(red)
        end
        local green = string.match(subset, '(%d+) green')
        if green then
            s.green = tonumber(green)
        end
        if next(s) ~= nil then
            table.insert(game.subsets, s)
        end
    end
    return game
end

local function max_color(game, color)
    return fun.reduce(game.subsets, function(current_max, subset)
        if subset[color] == nil then
            return current_max
        end
        if current_max < subset[color] then
            return subset[color]
        else
            return current_max
        end
    end, 0)
end

function M.is_game_possible(game, configuration)
    local max_green = max_color(game, 'green')
    local max_blue = max_color(game, 'blue')
    local max_red = max_color(game, 'red')
    return (max_green <= configuration.green) and (max_red <= configuration.red) and (max_blue <= configuration.blue)
end

M.configuration_part1 = {
    ['blue'] = 14,
    ['red'] = 12,
    ['green'] = 13,
}

function M.part1(input_file)
    local sum = 0
    for l in io.lines(input_file) do
        local game = M.parse_game(l)
        if M.is_game_possible(game, M.configuration_part1) then
            sum = sum + game.id
        end
    end
    return sum
end

function M.min_game_power(game)
    local colors = {'green', 'blue', 'red'}
    local mul = 1
    for _,c in ipairs(colors) do
        local max = max_color(game, c)
        mul = mul * max
    end
    return mul
end

function M.part2(input_file)
    local sum = 0
    for l in io.lines(input_file) do
        local game = M.parse_game(l)
        local power = M.min_game_power(game)
        sum = sum + power
    end
    return sum
end


M.solution_part1 = 2683
M.solution_part2 = 49710

return M
