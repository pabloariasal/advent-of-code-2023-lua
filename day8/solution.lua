local util = require 'util'
local fun = require 'functional'
local inspect = require 'inspect'

local M = {}

function M.parse_instruction(instruction)
    local f,l,r = string.match(instruction, '^(%a+)%s*=%s*%((%a+),%s*(%a+)%)$')
    return { from = f, left = l, right = r}
end

local function single_step(l_or_r, current, instructions)
    if l_or_r == 'L' then
        return instructions[current].left
    else
        return instructions[current].right
    end
end

function M.count_steps_from_a_to_z(lr_instruction, instructions, start, ep)
    local current = start
    local instruction_index = 1
    local hops = 0
    while not string.find(current, ep) do
        current = single_step(string.sub(lr_instruction, instruction_index, instruction_index), current, instructions)
        hops = hops + 1
        instruction_index = instruction_index + 1
        if instruction_index > #lr_instruction then
            instruction_index = 1
        end
    end
    return hops
end

local function get_starting(instructions)
    local result = {}
    for k,_ in pairs(instructions) do
        if string.find(k, '^..A$') then
            table.insert(result, k)
        end
    end
    return result
end

-- Function to calculate the greatest common divisor (GCD)
local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return math.abs(a)
end

local function lcm(a, b)
    return math.abs(a * b) / gcd(a, b)
end

-- Function to calculate the least common multiple (LCM) of numbers in a table
local function lcm_of_table(numbers)
    if #numbers < 2 then
        return "Error: Need at least two numbers to calculate LCM."
    end

    local result = numbers[1]
    for i = 2, #numbers do
        result = lcm(result, numbers[i])
    end

    return result
end

function M.count_steps_from_a_to_z_part2(lr_instruction, instructions)
    local current = get_starting(instructions)
    local hops = {}
    for _,c in ipairs(current) do
        table.insert(hops, M.count_steps_from_a_to_z(lr_instruction, instructions, c, '^..Z$'))
    end
    return lcm_of_table(hops)
end

function M.part1(input_file)
    local it = io.lines(input_file)
    local lr_instruction = it()
    local instructions = {}
    it() -- consume empty line
    for l in it do
        local i = M.parse_instruction(l)
        instructions[i.from] = {left = i.left, right = i.right}
    end
    return M.count_steps_from_a_to_z(lr_instruction, instructions, 'AAA', 'ZZZ')
end

function M.part2(input_file)
    local it = io.lines(input_file)
    local lr_instruction = it()
    local instructions = {}
    it() -- consume empty line
    for l in it do
        local i = M.parse_instruction(l)
        instructions[i.from] = {left = i.left, right = i.right}
    end
    return math.floor(M.count_steps_from_a_to_z_part2(lr_instruction, instructions))
end

M.solution_part1 = 18113
M.solution_part2 = 12315788159977

return M
