local st = require 'string-utils'
local util = require 'util'
local fun = require 'functional'

local function parse_game(game_str)
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
        -- print(util.dump(subset))
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

local function is_game_possible(game, configuration)
    local max_green = max_color(game, 'green')
    local max_blue = max_color(game, 'blue')
    local max_red = max_color(game, 'red')
    return (max_green <= configuration.green) and (max_red <= configuration.red) and (max_blue <= configuration.blue)
end

local configuration_part1 = {
    ['blue'] = 14,
    ['red'] = 12,
    ['green'] = 13,
}

local function part1()
    local sum = 0
    for l in io.lines(arg[1]) do
        local game = parse_game(l)
        if is_game_possible(game, configuration_part1) then
            sum = sum + game.id
        end
    end
    return sum
end

print("Part 1: " .. part1())
assert(part1() == 2683)

local function min_game_power(game)
    local colors = {'green', 'blue', 'red'}
    local mul = 1
    for _,c in ipairs(colors) do
        local max = max_color(game, c)
        mul = mul * max
    end
    return mul
end

local function part2()
    local sum = 0
    for l in io.lines(arg[1]) do
        local game = parse_game(l)
        local power = min_game_power(game)
        sum = sum + power
    end
    return sum
end

print("Part 2: " .. part2())

-- Test Cases part 1
local testcases_part1 = {
    { input = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',                   expected = true },
    { input = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',         expected = true },
    { input = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red', expected = false },
    { input = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red', expected = false },
    { input = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',                   expected = true },
}

for _, v in ipairs(testcases_part1) do
    local game = parse_game(v.input)
    local actual = is_game_possible(game, configuration_part1)
    assert(actual == v.expected, string.format('Input: %s, Actual: %s, Expected: %s, Config: %s', v.input, v.expected, actual, util.dump(configuration_part1)))
end

-- Test Cases part 2
local testcases_part2 = {
    { input = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',                   expected = 48 },
    { input = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',         expected = 12 },
    { input = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red', expected = 1560 },
    { input = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red', expected = 630 },
    { input = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',                   expected = 36 },
}

for _, v in ipairs(testcases_part2) do
    local game = parse_game(v.input)
    local actual = min_game_power(game)
    assert(actual == v.expected, string.format('Input: %s, Actual: %s, Expected: %s', v.input, actual, v.expected))
end
