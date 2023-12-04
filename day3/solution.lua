local util = require 'util'
local fun = require 'functional'

local M = {}

function M.isDigit(str)
    return (str:find("^%d") ~= nil)
end

function M.isPoint(str)
    return (str:find('^%.') ~= nil)
end

function M.isDollar(str)
    return (str:find('^%$') ~= nil)
end

function isStar(str)
    return (str:find('^%*') ~= nil)
end

function M.isSymbol(str)
    return not M.isDigit(str) and not M.isPoint(str) or M.isDollar(str)
end

local function extract_numbers_and_symbols_from_line(line, line_number)
    local numbers = {}
    local symbols = {}

    local number_start = nil
    local number_end = nil
    for j = 1, #line do
        local current_char = string.sub(line, j, j)
        if M.isDigit(current_char) then
            if number_start == nil then
                -- starting a new number
                number_start = j
            end
            number_end = j
        else
            if (number_start ~= nil) then
                -- ending a number
                local num = tonumber(string.sub(line, number_start, number_end))
                table.insert(numbers, { number = num, start_col = number_start, row = line_number, end_col = number_end })
            end
            number_start = nil
            number_end = nil
            if M.isSymbol(current_char) then
                table.insert(symbols, { symbol = current_char, col = j, row = line_number })
            end
        end
    end
    if (number_start ~= nil) then
        -- ending a number
        local num = tonumber(string.sub(line, number_start, number_end))
        table.insert(numbers, { number = num, start_col = number_start, row = line_number, end_col = number_end })
    end
    return numbers, symbols
end

local function extract_numbers_and_symbols(lines)
    local numbers = {}
    local symbols = {}
    for i, l in ipairs(lines) do
        local n, s = extract_numbers_and_symbols_from_line(l, i)
        util.insert_all(numbers, n)
        util.insert_all(symbols, s)
    end
    return numbers, symbols
end

local function is_adjacent_to_number(number, row, col)
    local row_in_range = (row >= number.row - 1) and (row <= number.row + 1)
    local col_in_range = (col >= number.start_col - 1) and (col <= number.end_col + 1)
    return row_in_range and col_in_range
end

local function input_as_table(input_file)
    local lines = {}
    for l in io.lines(input_file) do
        table.insert(lines, l)
    end
    return lines
end

function M.part1(input_file)
    local lines = input_as_table(input_file)
    local numbers,symbols = extract_numbers_and_symbols(lines)
    local result = 0
    for _,n in ipairs(numbers) do
        for _,s in ipairs(symbols) do
            if is_adjacent_to_number(n, s.row, s.col) then
                result = result + n.number
                break
            end
        end
    end
    return result
end

function M.part2(input_file)
    local lines = input_as_table(input_file)
    local numbers,symbols = extract_numbers_and_symbols(lines)
    local stars = fun.filter(symbols, function(s) return isStar(s.symbol) end)
    local result = 0
    for _,s in ipairs(stars) do
        local adjacent_numbers = {}
        for _,n in ipairs(numbers) do
            if is_adjacent_to_number(n, s.row, s.col) then
                table.insert(adjacent_numbers, n.number)
            end
        end
        if #adjacent_numbers == 2 then
            result = result + (adjacent_numbers[1] * adjacent_numbers[2])
        end
    end
    return result
end

M.solution_part1 = 517021
M.solution_part2 = 81296995

return M
