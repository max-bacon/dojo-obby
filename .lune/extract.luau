--[[

lune extract.luau

]]

local roblox = require("@lune/roblox")
local fs = require("@lune/fs")

local ignore = {
	"Camera",
	"Packages",
	"Terrain",
}

local restrict = {}

local placeFile = fs.readFile(".lune/map.rbxl")
local game = roblox.deserializePlace(placeFile)

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

local function main(save: string, loc)
	fs.removeDir(save)
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

				fs.writeFile(save .. model.Name .. i .. ".rbxm", roblox.serializeModel({model}))
			else
				fs.writeFile(save .. model.Name .. ".rbxm", roblox.serializeModel({model}))
			end
		end
	end
end

main("assets/Workspace/", game.Workspace)
main("assets/Lighting/", game.Lighting)
main("assets/ServerStorage/", game.ServerStorage)
