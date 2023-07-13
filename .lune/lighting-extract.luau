--[[

lune lighting-extract.luau

]]

local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local save = "assets/Lighting/"

local placeFile = fs.readFile(".lune/map.rbxl")
local game = roblox.deserializePlace(placeFile)

local function isFile(name: string)
	if fs.isFile(name .. ".rbxm") then
		return true
	else
		return false
	end
end

fs.removeDir(save)
local Models = game.Lighting
fs.writeDir(save)

for _, model in ipairs(Models:GetChildren()) do
	print(model.Name)
	if isFile(save .. model.Name) then
		local i = 0
		repeat
			i = i + 1
		until not isFile(save .. model.Name .. i)

		fs.writeFile(save .. model.Name .. i .. ".rbxm", roblox.serializeModel({ model }))
	else
		fs.writeFile(save .. model.Name .. ".rbxm", roblox.serializeModel({ model }))
	end
end
