--[[
	Disables the ability to reassign values for tables and makes them "read only"
	Only works for the first layer, so don't go making multi layered tables please thanks :)
	
	References: http://lua-users.org/wiki/ReadOnlyTables
--]]

local function RestrictedTable(table)
	return setmetatable({}, {
		__index = table,
		__newindex = function()
			warn("Attempt to modify read-only table. Operation failed \n Contact DataSigh for more info")
			end,
		__metatable = false
	});
end

return RestrictedTable