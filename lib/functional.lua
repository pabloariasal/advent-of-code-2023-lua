local M = {}

function M.map(sequence, transformation)
    local newlist = { }
    for i, v in pairs(sequence) do
        newlist[i]=transformation(v)
    end
    return newlist
end

function M.filter(sequence, predicate)
    local newlist = { }
    for _, v in ipairs(sequence) do
        if predicate(v) then
            table.insert(newlist, v)
       end
    end
end

function M.partition(sequence, predicate)
    local left = { }
    local right = { }
    for _, v in ipairs(sequence) do
        if (predicate(v)) then
            table.insert(left, v)
        else
            table.insert(right,v)
        end
    end
    return left, right
end

function M.reduce(sequence, operator, init)
    if #sequence == 0 then
        return nil
    end
    local out=init
    for i=1,#sequence do
        out=operator(out, sequence[i])
    end
    return out
end

return M
