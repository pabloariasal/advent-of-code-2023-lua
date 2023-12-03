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

local function isSymbol(str)
  return not isDigit(str) and not isPoint(str) or isDollar(str)
end

-- Test

local function test_is_digit()
    local testcases = {
        {input = '+', expected = false},
        {input = '#', expected = false},
        {input = '*', expected = false},
        {input = '5', expected = true},
        {input = '.', expected = false},
    }
    for _,v in ipairs(testcases) do
        local actual = isDigit(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function test_is_point()
    local testcases = {
        {input = '+', expected = false},
        {input = '#', expected = false},
        {input = '*', expected = false},
        {input = '5', expected = false},
        {input = '.', expected = true},
    }
    for _,v in ipairs(testcases) do
        local actual = isPoint(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function test_is_symbol()
    local testcases = {
        {input = '+', expected = true},
        {input = '#', expected = true},
        {input = '*', expected = true},
        {input = '$', expected = true},
        {input = '5', expected = false},
        {input = '.', expected = false},
    }
    for _,v in ipairs(testcases) do
        local actual = isSymbol(v.input)
        assert(actual == v.expected, util.dump(v))
    end
end

local function has_as_neighbor(col, current_line, prev_line, next_line, pred)
    local cols = {col -1, col, col + 1}
    for _,c in ipairs(cols) do
        if (c > 0) and (c <= #current_line) then
            if prev_line ~= nil and pred(string.sub(prev_line, c, c)) then
                return true
            end
            if next_line ~= nil and pred(string.sub(next_line, c, c)) then
                return true
            end
            if pred(string.sub(current_line, c, c)) then
                return true
            end
       end
    end
    return false
end

local function has_symbol_as_neighbor(col, current_line, prev_line, next_line)
    return has_as_neighbor(col, current_line, prev_line, next_line, isSymbol)
end

-- Tests

local function test_has_symbol_as_neighbor()
    local testcases = {
        {current = '123', col = 1, prev = nil, next = nil, expected=false },
        {current = '12+', col = 1, prev = nil, next = nil, expected=false },
        {current = '12+', col = 2, prev = nil, next = nil, expected=true },
        {current = '123', col = 1, prev = '+34', next = nil, expected=true },
        {current = '123', col = 2, prev = '+34', next = nil, expected=true },
        {current = '123', col = 3, prev = '+34', next = nil, expected=false },
        {current = '123', col = 3, prev = '345', next = '+78', expected=false },
        {current = '123', col = 2, prev = '666', next = '+78', expected=true },
        {current = '123', col = 1, prev = '666', next = '+78', expected=true },
    }
    for _,t in ipairs(testcases) do
        local actual = has_symbol_as_neighbor(t.col, t.current, t.prev, t.next)
        assert(actual == t.expected, util.dump(t))
    end
end

local function adjacent_numbers_in_line(current_line, prev_line, next_line)
    local numbers = {}

    local number_start = nil
    local number_end = nil
    local is_adjacent = false
    for j=1,#current_line do
        local current_char = string.sub(current_line, j, j)
        if isDigit(current_char) then
            if number_start == nil then
                -- starting a new number
                number_start = j
            end
            number_end = j
            if not is_adjacent and has_symbol_as_neighbor(j, current_line, prev_line, next_line) then
                is_adjacent = true
            end
        else
            if (number_start ~= nil) and is_adjacent then
                -- ending a number
                table.insert(numbers, tonumber(string.sub(current_line, number_start, number_end)))
            end
            number_start = nil
            number_end = nil
            is_adjacent = false
        end
    end
    if (number_start ~= nil) and is_adjacent then
        -- ending a number
        table.insert(numbers, tonumber(string.sub(current_line, number_start, number_end)))
    end
    return numbers
end

-- Tests

local function test_adjacent_numbers_in_line()
    local testcases = {
        {current = '123.456', prev = nil, next = nil, expected={} },
        {current = '123.456', prev = '+......', next = nil, expected={123} },
        {current = '123.456', prev = '.......', next = '......+', expected={456} },
        {current = '123.456', prev = '+......', next = '.......', expected={123} },
        {current = '123.456', prev = '+......', next = '......+', expected={123, 456} },
    }
    for _,t in ipairs(testcases) do
        local actual = adjacent_numbers_in_line(t.current, t.prev, t.next)
        assert(#actual == #t.expected, string.format("Actual: %s, Input: %s ", util.dump(actual), util.dump(t)))
        for i,n in ipairs(t.expected) do
            assert(actual[i] == n, string.format("Actual: %s, Input: %s ", util.dump(actual), util.dump(t)))
        end
    end
end

local function adjacent_numbers(lines)
    local numbers = {}
    for i,current_line in ipairs(lines) do
        local numbers_in_line = adjacent_numbers_in_line(current_line, lines[i - 1], lines[i + 1])
        for _,v in ipairs(numbers_in_line) do 
            table.insert(numbers, v)
        end
    end
    return numbers
end

-- Test

local test_input = {
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598..",
}

local function test_adjacent_numbers()
    local actual = adjacent_numbers(test_input)
    local expected = {467, 35, 633, 617, 592, 755, 664, 598}
    assert(#expected == #actual, util.dump(actual))
    for i,v in ipairs(expected) do
        assert(actual[i] == v)
    end
end

local function part1()
    local lines = {}
   for l in io.lines(arg[1]) do
        table.insert(lines, l)
   end
   return fun.reduce(adjacent_numbers(lines), fun.sum, 0)
end

local p1 = part1()
print(p1)
assert(p1 == 517021)

test_is_symbol()
test_is_point()
test_is_digit()
test_has_symbol_as_neighbor()
test_adjacent_numbers_in_line()
test_adjacent_numbers()
