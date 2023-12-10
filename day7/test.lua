local s = require('solution')
local lu = require('luaunit')
local util = require('util')
local inspect = require 'inspect'

function test_parse_hand()
    local input = '32T3K 765'
    local expected = {hand = '32T3K', bid = '765'}
    local actual = s.parse_hand(input)
    lu.assertEquals(actual, expected)
end

function test_get_type_part1()
    local test_input = {
        {input = 'AAAAA', expected = 'five_of_a_kind'},
        {input = 'AA8AA', expected = 'four_of_a_kind'},
        {input = '23332', expected = 'fullhouse'},
        {input = 'TTT98', expected = 'three_of_a_kind'},
        {input = '23432', expected = 'two_pair'},
        {input = 'A23A4', expected = 'one_pair'},
        {input = '23456', expected = 'high_card'},
    }
    for _,t in ipairs(test_input) do
        lu.assertEquals(s.get_type(t.input), t.expected)
    end
end

function test_get_type_part2()
    local test_input = {
        {input = '32T3K', expected = 'one_pair'},
        {input = 'T55J5', expected = 'four_of_a_kind'},
        {input = 'KK677', expected = 'two_pair'},
        {input = 'KTJJT', expected = 'four_of_a_kind'},
        {input = 'QQQJA', expected = 'four_of_a_kind'},
        {input = 'JJJJJ', expected = 'five_of_a_kind'},
        {input = 'JJJJQ', expected = 'five_of_a_kind'},
        {input = 'JJJQQ', expected = 'five_of_a_kind'},
        {input = 'JJJQA', expected = 'four_of_a_kind'},
        {input = 'JJQQQ', expected = 'five_of_a_kind'},
        {input = 'JJQQA', expected = 'four_of_a_kind'},
        {input = 'JJQTA', expected = 'three_of_a_kind'},
        {input = 'JQQQQ', expected = 'five_of_a_kind'},
        {input = 'JAQQQ', expected = 'four_of_a_kind'},
        {input = 'JATQQ', expected = 'three_of_a_kind'},
        {input = 'JATQ4', expected = 'one_pair'},
        {input = 'AAAAA', expected = 'five_of_a_kind'},
        {input = 'AA8AA', expected = 'four_of_a_kind'},
        {input = '23332', expected = 'fullhouse'},
        {input = 'TTT98', expected = 'three_of_a_kind'},
        {input = '23432', expected = 'two_pair'},
        {input = 'A23A4', expected = 'one_pair'},
        {input = '23456', expected = 'high_card'},
    }
    for _,t in ipairs(test_input) do
        lu.assertEquals(s.get_type_part2(t.input), t.expected, t.input)
    end
end

function test_is_type_better()
   local test_input = {
        {lhs = 'five_of_a_kind', rhs = 'four_of_a_kind', expected = true},
        {lhs = 'five_of_a_kind', rhs = 'five_of_a_kind', expected = false},
        {lhs = 'fullhouse', rhs = 'three_of_a_kind', expected = true},
    }
    for _,t in ipairs(test_input) do
        lu.assertEquals(s.is_type_better(t.lhs, t.rhs), t.expected)
    end
end

function test_compute_winnings_part1()
    local input = {
        {hand = '32T3K', bid = '765', type = 'one_pair'},
        {hand = 'T55J5', bid = '684', type = 'three_of_a_kind'},
        {hand = 'KK677', bid = '28', type = 'two_pair'},
        {hand = 'KTJJT', bid = '220', type = 'two_pair'},
        {hand = 'QQQJA', bid = '483', type = 'three_of_a_kind'},
    }
    lu.assertEquals(s.compute_winnings(input, s.weights_part1), 6440)
end

function test_compute_winnings_part2()
    local input = {
        {hand = '32T3K', bid = '765', type = 'one_pair'},
        {hand = 'T55J5', bid = '684', type = 'four_of_a_kind'},
        {hand = 'KK677', bid = '28', type = 'two_pair'},
        {hand = 'KTJJT', bid = '220', type = 'four_of_a_kind'},
        {hand = 'QQQJA', bid = '483', type = 'four_of_a_kind'},
    }
    lu.assertEquals(s.compute_winnings(input, s.weights_part2), 5905)
end


os.exit( lu.LuaUnit.run() )
