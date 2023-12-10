local util = require 'util'
local fun = require 'functional'
local fu = require 'file-utils'
local su = require 'string-utils'
local inspect = require 'inspect'

local M = {}

function M.parse_seeds(input_str)
    return fun.map(su.split_string(input_str:gsub('^[sS]eeds:', ''), ' '), tonumber)
end

local function split_string_list_by_pattern(t, pat)
    local result = {}
    for _,v in ipairs(t) do
        if v:find(pat) then
            table.insert(result, {})
        else
            if not v:find('^%s+$') then
                table.insert(result[#result], v)
            end
        end
    end
    return result
end

function M.parse_maps(input_str)
    local map = {}
    local maps = su.split_string(input_str, '\n')
    table.remove(maps, 1)
    local ranges = split_string_list_by_pattern(maps, '^.+map:')
    for _,rs in ipairs(ranges) do
        local current_ranges = {}
        for _,r in ipairs(rs) do
            local current_range = su.split_string(r, ' ')
            table.insert(current_ranges, fun.map(current_range, tonumber))
        end
        table.insert(map, current_ranges)
    end
    return map
end

function M.map_once(current_id, current_map)
    -- map is a list of ranges
    for _,r in ipairs(current_map) do
        local source_begin = r[2]
        local range_length = r[3]
        local destination_begin = r[1]
        if (current_id >= source_begin) and (current_id <= source_begin + range_length) then
            -- we are in range
            return destination_begin + (current_id - source_begin)
        end
    end
    return current_id
end

local function map_seed_to_location(seed, maps)
    return fun.reduce(maps,
        function(current_num, current_map)
            return M.map_once(current_num, current_map)
        end,
        seed)
end

local function find_min(list)
    local min = list[1]
    for _,v in ipairs(list) do
        if v < min then
            min = v
        end
    end
    return min
end

function M.part1(input_file)
    local contents = fu.read_file_to_string(input_file)
    local seeds = M.parse_seeds(contents)
    local maps = M.parse_maps(contents)
    local locations = fun.map(seeds,
        function(seed) return map_seed_to_location(seed, maps) end)
    return find_min(locations)
end

function M.part2(input_file)
    return 0
    -- local contents = fu.read_file_to_string(input_file)
    -- local seeds = M.parse_seeds(contents)
    -- local maps = M.parse_maps(contents)
    -- local min_location = nil
    -- local cache = {}
    -- for i=1,#seeds,2 do
    --     local b = seeds[i]
    --     local e = b + seeds[i+1]
    --     print(b)
    --     print(e)
    --     for seed=b,e do
    --         if not cache[seed] then
    --             cache[seed] = map_seed_to_location(seed, maps)
    --         else
    --             print('hit')
    --         end
    --         if (not min_location) or (cache[seed] < min_location) then
    --             min_location = cache[seed]
    --         end
    --     end
    -- end
    -- return min_location
end

M.solution_part1 = 51580674
M.solution_part2 = 0

return M
