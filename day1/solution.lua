local util = require 'util'
local fun = require 'functional'

local function part1()
   local codes = { }
   local lines = io.lines(arg[1])
   for l in lines do
      local rev = string.reverse(l)

      local first = string.find(l, '%d')
      local last = string.find(rev, '%d')
      first = string.sub(l, first, first)
      last = string.sub(rev, last, last)

      local number = tonumber(first .. last)
      table.insert(codes, number)
   end
   return fun.reduce(codes, fun.sum, 0)
end

local p1 = part1()
print("Part 1: " .. p1)
assert(55607 == p1)

local nums = {['one'] = 1,
   ['two'] = 2,
   ['three'] = 3,
   ['four'] = 4,
   ['five'] = 5,
   ['six'] = 6,
   ['seven'] = 7,
   ['eight'] = 8,
   ['nine'] = 9,
}

local function get_numbers(line)
   local numbers = {}
   for i=1,#line do
      local str = string.sub(line, i)
      if string.match(str, '^%d') then
         table.insert(numbers, tonumber(string.sub(str, 1, 1)))
      else
         for k,v in pairs(nums) do
            if string.match(str, '^' .. k) then
               table.insert(numbers, v)
               break
            end
         end
      end
   end
   return numbers
end

local function calibration_sum(line)
   local n = get_numbers(line)
   return tonumber(n[1] .. n[#n])
end

function part2()
   local sum = 0
   for l in io.lines(arg[1]) do
      sum = sum + calibration_sum(l)
   end
   return sum
end

local p2 = part2()
print("Part 2:" .. p2)
assert(55607 == p2)

-- Tests
local testcases = {
   {input = "two1nine", expected = 29},
   {input = "eightwothree", expected = 83},
   {input = "abcone2threexyz", expected = 13},
   {input = "xtwone3four", expected = 24},
   {input = "4nineeightseven2", expected = 42},
   {input = "zoneight234", expected = 14},
   {input = "7pqrstsixteen", expected = 76},
}

for _, t in ipairs(testcases) do
   local actual = calibration_sum(t.input)
   assert(actual == t.expected, (string.format('Input: %s Expected: %s Actual: %s', t.input, t.expected, actual)))
end
