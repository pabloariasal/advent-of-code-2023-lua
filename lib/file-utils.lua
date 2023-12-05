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

return M
