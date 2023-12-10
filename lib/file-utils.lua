local M = {}

function M.read_file(input_file)
    local file = io.open(input_file, 'r')
    if not file then
        return nil
    end
    local contents = file:read('a')
    file:close()
    return contents
end

function M.parse_line(input_file, parse)
    local it = io.lines(input_file)
    return function()
        local next = it()
        if next ~= nil then
            return parse(next)
        end
    end
end

return M
