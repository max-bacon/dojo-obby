--[[

lune server-storage-extract.lua

]]

local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local ignore = {
	"Packages",
}

local restrict = {}

local save = "assets/ServerStorage/"

local game = roblox.readPlaceFile(".lune/map.rbxl")

local function check(name, checkArr)
	for _, c in pairs(checkArr) do
		if c == name then
			return true
		end
	end
	return false
end

local function isFile(name: string)
	-- print(name)
	if fs.isFile(name .. ".rbxm") then
		return true
	else
		return false
	end
end

local Models = game.ServerStorage
fs.writeDir(save)

for _, model in ipairs(Models:GetChildren()) do
	print(model.Name)
	if not check(model.Name, ignore) then
		if isFile(save .. model.Name) and not check(model.Name, restrict) then
			local i = 0
			repeat
				i = i + 1
			until not isFile(save .. model.Name .. i)

			roblox.writeModelFile(save .. model.Name .. i .. ".rbxm", { model })
		else
			roblox.writeModelFile(save .. model.Name .. ".rbxm", { model })
		end
	end
end
