local s = require('solution')
local lu = require('luaunit')
local util = require('util')
local inspect = require 'inspect'

function test_parse_instruction()
    local input = "AAA = (BBB, CCC)"
    local expected = { from = 'AAA', left = "BBB", right = "CCC" }
    local actual = s.parse_instruction(input)
    lu.assertEquals(actual, expected)
end

function test_count_steps()
    local input = {
        ['AAA'] = { left = 'BBB', right = 'CCC' },
        ['BBB'] = { left = 'DDD', right = 'EEE' },
        ['CCC'] = { left = 'ZZZ', right = 'GGG' },
        ['DDD'] = { left = 'DDD', right = 'DDD' },
        ['EEE'] = { left = 'EEE', right = 'EEE' },
        ['GGG'] = { left = 'GGG', right = 'GGG' },
        ['ZZZ'] = { left = 'ZZZ', right = 'ZZZ' },
    }
    local actual = s.count_steps_from_a_to_z('RL', input, 'AAA', 'ZZZ')
    lu.assertEquals(actual, 2)
    input = {
        ['AAA'] = { left = 'BBB', right = 'BBB' },
        ['BBB'] = { left = 'AAA', right = 'ZZZ' },
        ['ZZZ'] = { left = 'ZZZ', right = 'ZZZ' },
    }
    actual = s.count_steps_from_a_to_z('LLR', input, 'AAA', 'ZZZ')
    lu.assertEquals(actual, 6)
end

function test_count_steps_part2()
    local input = {
        ['11A'] = { left = '11B', right = 'XXX' },
        ['11B'] = { left = 'XXX', right = '11Z' },
        ['11Z'] = { left = '11B', right = 'XXX' },
        ['22A'] = { left = '22B', right = 'XXX' },
        ['22B'] = { left = '22C', right = '22C' },
        ['22C'] = { left = '22Z', right = '22Z' },
        ['22Z'] = { left = '22B', right = '22B' },
        ['XXX'] = { left = 'XXX', right = 'XXX' },
    }
    lu.assertEquals(s.count_steps_from_a_to_z_part2('LR', input), 6)
end

os.exit(lu.LuaUnit.run())
