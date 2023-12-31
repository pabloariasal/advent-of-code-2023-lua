local M = {}

function M.split_string(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function M.lines(inputstr)
    return M.split_string(inputstr, '\n')
end

return M
