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

function M.are_lists_equal(l1, l2)
   if #l1 ~= #l2 then
      return false
   end
   for i,v in ipairs(l1) do
      if v ~= l2[i] then
         return false
      end
   end
   return true
end

function M.range(f, t, s)
   local result = {}
   for i=f,t,(s or 1) do
      table.insert(result, i)
   end
   return result
end

return M
