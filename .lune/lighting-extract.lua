--[[

lune lighting-extract.lua

]]


local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local save = "assets/Lighting/"

local game = roblox.readPlaceFile(".lune/map.rbxl")

local function isFile(name)
	if fs.isFile(name .. ".rbxmx") then
		return true
	else
		return false
	end
end

local Models = game.Lighting
fs.writeDir(save)

for _, model in ipairs(Models:GetChildren()) do
	print(model.Name)
	if isFile(save .. model.Name) then
		local i = 0
		repeat
			i = i + 1
		until not isFile(save .. model.Name .. i)

		roblox.writeModelFile(save .. model.Name .. i .. ".rbxmx", {model})
	else
		roblox.writeModelFile(save .. model.Name .. ".rbxmx", {model})
	end
end