local M = {}

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.insert_all(t, l)
   local result = t
   for _,v in ipairs(l) do
      table.insert(result, v)
   end
   return result
end

function M.insert_all_it(t, it)
   local result = t
   for v in it do
      table.insert(result, v)
   end
   return result
end

function M.is_in_list(l, e)
   for i=1,#l do
      if l[i] == e then
         return true
      end
   end
   return false
end

return M
