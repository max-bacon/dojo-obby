--[[

lune extract.lua

]]

local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local ignore = {
	"Camera",
	"Packages",
}

local restrict = {
	"Terrain",
}

local game = roblox.readPlaceFile(".lune/map.rbxl")

local function check(name, checkArr)
	for _, c in pairs(checkArr) do
		if c == name then
			return true
		end
	end
	return false
end

local function isFile(name)
	-- print(name)
	if fs.isFile(name .. ".rbxmx") then
		return true
	else
		return false
	end
end

local function main(save, loc)
	local Models = loc
	fs.writeDir(save)

	for _, model in ipairs(Models:GetChildren()) do
		print(model.Name)
		if not check(model.Name, ignore) then
			if isFile(save .. model.Name) and not check(model.Name, restrict) then
				local i = 0
				repeat
					i = i + 1
				until not isFile(save .. model.Name .. i)

				roblox.writeModelFile(save .. model.Name .. i .. ".rbxmx", { model })
			else
				roblox.writeModelFile(save .. model.Name .. ".rbxmx", { model })
			end
		end
	end
end

main("assets/Workspace/", game.Workspace)
main("assets/Lighting/", game.Lighting)
main("assets/ServerStorage/", game.ServerStorage)
