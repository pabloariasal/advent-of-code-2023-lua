local M = {}

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

function M.range(f, t, s)
   local result = {}
   for i=f,t,(s or 1) do
      table.insert(result, i)
   end
   return result
end

return M
