local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player, country)
	local newTycoon = setmetatable({}, Tycoon)
	
	newTycoon.Player = player
	newTycoon.Country = country
	newTycoon.Money = 0
	
	
	return newTycoon
end

return Tycoon