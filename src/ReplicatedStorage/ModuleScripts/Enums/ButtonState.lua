--[[
    Handle the different button states, specifically for images in fusion
]]

local RestrictedTable = require(script.Parent.RestrictedTable)

local ButtonState = RestrictedTable{
    Up = "Up",
    Hover = "Hover",
    Pressed = "Pressed",
}

return ButtonState