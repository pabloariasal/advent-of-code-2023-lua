local fun = require 'functional'

local M = {}

function M.part1(input_file)
   local codes = { }
   local lines = io.lines(input_file)
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

function M.calibration_sum(line)
   local n = get_numbers(line)
   return tonumber(n[1] .. n[#n])
end

function M.part2(input_file)
   local sum = 0
   for l in io.lines(input_file) do
      sum = sum + M.calibration_sum(l)
   end
   return sum
end

M.solution_part1 = 55607
M.solution_part2 = 55291

return M
