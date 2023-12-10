local util = require 'util'
local fun = require 'functional'
local inspect = require 'inspect'
local fu = require 'file-utils'

local M = {}

function M.parse_hand(hand_line)
    local hand = {}
    local h,b = string.match(hand_line, '^(.+)%s+(.+)$')
    hand.hand = h
    hand.bid = b
    return hand
end

M.weights_part1 = {
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['T'] = 10,
    ['J'] = 11,
    ['Q'] = 12,
    ['K'] = 13,
    ['A'] = 14,
}

M.weights_part2 = {
    ['1'] = 1,
    ['2'] = 2,
    ['3'] = 3,
    ['4'] = 4,
    ['5'] = 5,
    ['6'] = 6,
    ['7'] = 7,
    ['8'] = 8,
    ['9'] = 9,
    ['T'] = 10,
    ['J'] = 0,
    ['Q'] = 12,
    ['K'] = 13,
    ['A'] = 14,
}

local function get_ocurrences(hand)
    local ocurrences = {}
    for i=1,#hand do
        local index = string.sub(hand, i, i)
        if not ocurrences[index] then
            ocurrences[index] = 0
        end
        ocurrences[index] = ocurrences[index] + 1
    end
    local sorted = {}
    for k,v in pairs(ocurrences) do
        table.insert(sorted, {card = k, ocurrences = v})
    end
    local function compare(a,b)
        return a.ocurrences > b.ocurrences
    end
    table.sort(sorted, compare)
    return sorted
end

function M.get_type(hand)
    local ocurrences = get_ocurrences(hand)
    if ocurrences[1].ocurrences == 5 then
        return 'five_of_a_kind'
    elseif ocurrences[1].ocurrences == 4 then
        return 'four_of_a_kind'
    elseif ocurrences[1].ocurrences == 3 and ocurrences[2].ocurrences == 2 then
        return 'fullhouse'
    elseif ocurrences[1].ocurrences == 3 then
        return 'three_of_a_kind'
    elseif ocurrences[1].ocurrences == 2 and ocurrences[2].ocurrences == 2 then
        return 'two_pair'
    elseif ocurrences[1].ocurrences == 2 and ocurrences[2].ocurrences == 2 then
        return 'two_pair'
    elseif ocurrences[1].ocurrences == 2 then
        return 'one_pair'
    end

   return 'high_card'
end

local function number_of_js(o)
    local t = {}
    local num_js = 0
    for _,o in ipairs(o) do
        if o.card == 'J' then
            num_js = o.ocurrences
        else
            table.insert(t, o)
        end
    end
    return num_js, t
end

function M.get_type_part2(hand)
    local o = get_ocurrences(hand)
    local num_js, occ = number_of_js(o)
    if num_js == 5 then
        return 'five_of_a_kind'
    end
    occ[1].ocurrences = occ[1].ocurrences + num_js
    if occ[1].ocurrences == 5 then
        return 'five_of_a_kind'
    elseif occ[1].ocurrences == 4 then
        return 'four_of_a_kind'
    elseif occ[1].ocurrences == 3 and occ[2].ocurrences == 2 then
        return 'fullhouse'
    elseif occ[1].ocurrences == 3 then
        return 'three_of_a_kind'
    elseif occ[1].ocurrences == 2 and occ[2].ocurrences == 2 then
        return 'two_pair'
    elseif occ[1].ocurrences == 2 and occ[2].ocurrences == 2 then
        return 'two_pair'
    elseif occ[1].ocurrences == 2 then
        return 'one_pair'
    end
   return 'high_card'
end

-- returns true is lhs has higher rank than rhs
function M.is_type_better(type_lhs, type_rhs)
    local w = {
        five_of_a_kind = 7,
        four_of_a_kind = 6,
        fullhouse = 5,
        three_of_a_kind = 4,
        two_pair = 3,
        one_pair = 2,
        high_card = 1,
    }
    return w[type_lhs] > w[type_rhs]
end

-- returns true if hand lsh wins over hand_rhs
local function compare_hands(weights, hand_lhs, hand_rhs)
    if hand_lhs.type ~= hand_rhs.type then
        return M.is_type_better(hand_lhs.type, hand_rhs.type)
    end
    for i=1,5 do
        local a = string.sub(hand_lhs.hand, i, i)
        local b = string.sub(hand_rhs.hand, i, i)
        if weights[a] > weights[b] then
            return true
        elseif weights[a] < weights[b] then
            return false
        end
    end
    return false
end

function M.compute_winnings(hands, weights)
    table.sort(hands, function(a,b) return compare_hands(weights, a, b)  end)
    local result = 0
    for i=1,#hands do
        local rank = #hands - i + 1
        result = result + (hands[i].bid * rank)
    end
    return result
end

function M.part1(input_file)
    local hands = {}
    for hand in fu.parse_line(input_file, M.parse_hand) do
        hand.type = M.get_type(hand.hand)
        table.insert(hands, hand)
    end
    return M.compute_winnings(hands, M.weights_part1)
end

function M.part2(input_file)
    local hands = {}
    for hand in fu.parse_line(input_file, M.parse_hand) do
        hand.type = M.get_type_part2(hand.hand)
        table.insert(hands, hand)
    end
    return M.compute_winnings(hands, M.weights_part2)
end

M.solution_part1 = 253205868
M.solution_part2 = 253907829

return M
