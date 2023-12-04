local s = require('solution')
local lu = require('luaunit')

local testcases = {
   {input = "two1nine", expected = 29},
   {input = "eightwothree", expected = 83},
   {input = "abcone2threexyz", expected = 13},
   {input = "xtwone3four", expected = 24},
   {input = "4nineeightseven2", expected = 42},
   {input = "zoneight234", expected = 14},
   {input = "7pqrstsixteen", expected = 76},
}

function test_calibration_sum()
   for _, t in ipairs(testcases) do
      local actual = s.calibration_sum(t.input)
      lu.assertEquals(actual, t.expected)
   end
end

os.exit( lu.LuaUnit.run() )
