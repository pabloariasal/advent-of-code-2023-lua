local util = require 'util'
local fun = require 'functional'

local function isDigit(str)
    return (str:find("^%d") ~= nil)
end

local function isPoint(str)
    return (str:find('^%.') ~= nil)
end

local function isDollar(str)
    return (str:find('^%$') ~= nil)
end

local function isStar(str)
    return (str:find('^%*') ~= nil)
end

local function isSymbol(str)
    return not isDigit(str) and not isPoint(str) or isDollar(str)
end

-- Test

local function test_is_digit()
    local testcases = {
        { input = '+', expected = false },
        { input = '#', expected = false },
        { input = '*', expected = false },
        { input = '5', expected = true },
        { input = '.', expected = false },
    }
    for _, v in ipairs(testcases) do
        local actual = isDigit(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function test_is_point()
    local testcases = {
        { input = '+', expected = false },
        { input = '#', expected = false },
        { input = '*', expected = false },
        { input = '5', expected = false },
        { input = '.', expected = true },
    }
    for _, v in ipairs(testcases) do
        local actual = isPoint(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function test_is_symbol()
    local testcases = {
        { input = '+', expected = true },
        { input = '#', expected = true },
        { input = '*', expected = true },
        { input = '$', expected = true },
        { input = '5', expected = false },
        { input = '.', expected = false },
    }
    for _, v in ipairs(testcases) do
        local actual = isSymbol(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function extract_numbers_and_symbols_from_line(line, line_number)
    local numbers = {}
    local symbols = {}

    local number_start = nil
    local number_end = nil
    for j = 1, #line do
        local current_char = string.sub(line, j, j)
        if isDigit(current_char) then
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
            if isSymbol(current_char) then
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

local function test_extract_numbers_and_symbols()
    local testcases = {
        {
            input = { '123..456' },
            expected_symbols = {},
            expected_numbers = {
                { number = 123, start_col = 1, end_col = 3, row = 1 },
                { number = 456, start_col = 6, end_col = 8, row = 1 } }
        },
        {
            input = { '123..456', '$23..*#1' },
            expected_symbols = {
                { symbol = '$', row = 2, col = 1 },
                { symbol = '*', row = 2, col = 6 },
                { symbol = '#', row = 2, col = 7 },
            },
            expected_numbers = {
                { number = 123, start_col = 1, end_col = 3, row = 1 },
                { number = 456, start_col = 6, end_col = 8, row = 1 },
                { number = 23,  start_col = 2, end_col = 3, row = 2 },
                { number = 1,   start_col = 8, end_col = 8, row = 2 },
            }
        }
    }

    for _, t in ipairs(testcases) do
        local actual_numbers, actual_symbols = extract_numbers_and_symbols(t.input)

        assert(#actual_numbers == #t.expected_numbers,
            string.format("Actual: %s, Input: %s ", util.dump(actual_numbers), util.dump(t)))
        for i, n in ipairs(t.expected_numbers) do
            assert(actual_numbers[i].number == n.number,
                string.format("Actual: %s, Input: %s ", util.dump(actual_numbers), util.dump(t)))
            assert(actual_numbers[i].start_col == n.start_col,
                string.format("Actual: %s, Input: %s ", util.dump(actual_numbers), util.dump(t)))
            assert(actual_numbers[i].end_col == n.end_col,
                string.format("Actual: %s, Input: %s ", util.dump(actual_numbers), util.dump(t)))
            assert(actual_numbers[i].row == n.row,
                string.format("Actual: %s, Input: %s ", util.dump(actual_numbers), util.dump(t)))
        end
        assert(#actual_symbols == #t.expected_symbols,
            string.format("Actual: %s, Input: %s ", util.dump(actual_symbols), util.dump(t)))
        for i, n in ipairs(t.expected_symbols) do
            assert(actual_symbols[i].symbol == n.symbol,
                string.format("Actual: %s, Input: %s ", util.dump(actual_symbols), util.dump(t)))
            assert(actual_symbols[i].col == n.col,
                string.format("Actual: %s, Input: %s ", util.dump(actual_symbols), util.dump(t)))
            assert(actual_symbols[i].row == n.row,
                string.format("Actual: %s, Input: %s ", util.dump(actual_symbols), util.dump(t)))
        end
    end
end

local function is_adjacent_to_number(number, row, col)
    local row_in_range = (row >= number.row - 1) and (row <= number.row + 1)
    local col_in_range = (col >= number.start_col - 1) and (col <= number.end_col + 1)
    return row_in_range and col_in_range
end

local function test_is_adjacent_to_number()
    local test_cases = {
        { input = { num = { number = 123, start_col = 2, end_col = 4, row = 2 }, row = 1, col = 1 }, expected = true },
        { input = { num = { number = 23, start_col = 3, end_col = 4, row = 2 }, row = 1, col = 1 }, expected = false },
        { input = { num = { number = 23, start_col = 3, end_col = 4, row = 2 }, row = 3, col = 2 }, expected = true },
        { input = { num = { number = 23, start_col = 3, end_col = 4, row = 2 }, row = 2, col = 5 }, expected = true },
        { input = { num = { number = 23, start_col = 3, end_col = 4, row = 2 }, row = 2, col = 6 }, expected = false },
    }
    for _,v in ipairs(test_cases) do
        local actual = is_adjacent_to_number(v.input.num, v.input.row, v.input.col)
        assert(actual == v.expected, util.dump(v))
    end
end

local function input_as_table()
    local lines = {}
    for l in io.lines(arg[1]) do
        table.insert(lines, l)
    end
    return lines
end

local function part1()
    local lines = input_as_table()
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

local p1 = part1()
print(p1)
assert(p1 == 517021)

local function part2()
    local lines = input_as_table()
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

local p2 = part2()
print(p2)
assert(p2 == 81296995)

test_is_symbol()
test_is_point()
test_is_digit()
test_extract_numbers_and_symbols()
test_is_adjacent_to_number()
