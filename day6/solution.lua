local util = require 'util'
local fun = require 'functional'
local inspect = require 'inspect'
local fu = require 'file-utils'
local su = require 'string-utils'

local M = {}

function M.parse_races(input)
    local lines = su.lines(input)

    local time_removed = string.gsub(lines[1], '^%s*Time:', '')
    local times = su.split_string(time_removed, '%s')

    local dist_removed = string.gsub(lines[2], '^%s*Distance:', '')
    local dists = su.split_string(dist_removed, '%s')
    assert(#dists == #times)

    local result = {}
    for i=1,#dists do
        table.insert(result, {time = tonumber(times[i]), distance = tonumber(dists[i])})
    end
    return result
end

function M.flatten(races)
    local race = {time = races[1].time, distance = races[1].distance }
    for i=2,#races do
        race.time = race.time .. races[i].time
        race.distance = race.distance .. races[i].distance
    end
    race.time = tonumber(race.time)
    race.distance = tonumber(race.distance)
    return race
end

function M.compute_distance(pressing_button_ms, total_time)
    local ms_running = total_time - pressing_button_ms
    local mm_per_ms = pressing_button_ms
    return mm_per_ms * ms_running
end

function M.get_possible_wins_per_race(race)
    local times_presing_button = util.range(0, race.time)
    local distances = fun.map(times_presing_button,
                              function(t) return {time = t, distance = M.compute_distance(t, race.time)} end)
    local distances_bigger_than_record = fun.filter(distances, function(d) return d.distance > race.distance end)
    return fun.map(distances_bigger_than_record, function(d) return d.time end)
end

function M.part1(input_file)
    local input = fu.read_file_to_string(input_file)
    local races = M.parse_races(input)
    local result = 1
    for _, r in ipairs(races) do
        result = result * #M.get_possible_wins_per_race(r)
    end
    return result
end

function M.part2(input_file)
    local input = fu.read_file_to_string(input_file)
    local races = M.parse_races(input)
    local race = M.flatten(races)
    local lower = math.ceil(race.time - math.sqrt(race.time * race.time - 4 * race.distance)) / 2
    local upper = math.floor(race.time + math.sqrt(race.time * race.time - 4 * race.distance)) / 2
    return math.floor(upper - lower)
end

M.solution_part1 = 32076
M.solution_part2 = 34278221

return M
