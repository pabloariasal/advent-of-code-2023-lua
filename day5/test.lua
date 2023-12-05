local s = require('solution')
local lu = require('luaunit')
local util = require('util')

function test_parse_seeds()
    lu.assertEquals(s.parse_seeds('seeds: 79 14 55 13'), { 79, 14, 55, 13 })
    lu.assertEquals(s.parse_seeds('seeds:     7955555 '), { 7955555 })
    lu.assertEquals(s.parse_seeds('seeds:'), {})
end

function test_parse_maps()
    local input = [[
        seeds: 79 14 55 13

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70
    ]]

    local expected = {
        {
            { 0,  15, 37 },
            { 37, 52, 2 },
            { 39, 0,  15 },
        },
        {
            { 49, 53, 8 },
            { 0,  11, 42 },
            { 42, 0,  7 },
            { 57, 7,  4 },
        },
        {
            { 88, 18, 7 },
            { 18, 25, 70 },
        } }

    lu.assertEquals(s.parse_maps(input), expected)
end

function test_map_once()
    local map = {{50, 98, 2}, {52, 50, 48}}
    lu.assertEquals(s.map_once(98, map), 50)
    lu.assertEquals(s.map_once(99, map), 51)
    lu.assertEquals(s.map_once(10, map), 10)
end

os.exit(lu.LuaUnit.run())
