local util = require 'util'
local fun = require 'functional'
local inspect = require 'inspect'
local su = require 'string-utils'
local fu = require 'file-utils'

local M = {}

local function are_all_zero(line)
    for _,v in ipairs(line) do
        if v ~= 0 then
            return false
        end
    end
    return true
end

local function grow_once(line)
    local result = {}
    for i=1,(#line - 1) do
        local item = line[i+1] - line[i]
        table.insert(result, item)
    end
    return result
end

function M.grow(line)
    local result = {}
    table.insert(result, line)
    local current = line
    while not are_all_zero(current) do
        local next = grow_once(current)
        assert(#next == #current - 1)
        table.insert(result, next)
        current = next
    end
    return result
end

local function last_element(row)
    return row[#row]
end

function M.interpolate_new_value(measurements)
    for i=#measurements,1,-1 do
        if i == #measurements then
            table.insert(measurements[i], 0)
        else
            local first = last_element(measurements[i+1])
            local second = last_element(measurements[i])
            table.insert(measurements[i], first + second)
        end
    end
    return last_element(measurements[1])
end

function M.extrapolate_backwards(measurements)
    for i=#measurements,1,-1 do
        if i == #measurements then
            table.insert(measurements[i], 1, 0)
        else
            local first = measurements[i+1][1]
            local second = measurements[i][1]
            table.insert(measurements[i], 1, second - first)
        end
    end
    return measurements[1][1]
end

local function parse_line(line)
    return fun.map(su.split_string(line, '%s'), tonumber)
end

function M.part1(input_file)
    local measurements = fu.parse_line(input_file, parse_line)
    local sum = 0
    for m in measurements do
        local g = M.grow(m)
        sum = sum + M.interpolate_new_value(g)
    end
    return sum
end

function M.part2(input_file)
    local measurements = fu.parse_line(input_file, parse_line)
    local sum = 0
    for m in measurements do
        local g = M.grow(m)
        sum = sum + M.extrapolate_backwards(g)
    end
    return sum
end

M.solution_part1 = 1868368343
M.solution_part2 = 1022

return M
