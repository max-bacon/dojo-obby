--[[
    Player state types
--]]

local RestrictedTable = require(script.Parent.RestrictedTable)

local PlayerState = RestrictedTable{
    Alive = "Alive",
    Limbo = "Limbo",
    Dead = "Dead",
    Spawning = "Spawning"
}

return PlayerState