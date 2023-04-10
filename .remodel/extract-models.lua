--[[
	Temp Model Folder:

	remodel run .remodel/extract-models.lua temp/models/
--]]

--[[
	Workspace Folder:
	
	remodel run .remodel/extract-models.lua assets/Workspace/
--]]

-- One use for Remodel is to pull data out of a place file and produce multiple
-- model files from it. This can be a hold-over for two-way sync in Rojo or to
-- sync models between multiple places!
--
-- Remodel can read place files with remodel.readPlaceFile. This returns a
-- DataModel instance, also known as game in Roblox!

local ignore = {
	"Camera",
}

local restrict = {
	"Terrain",
}

local save = ...

local game = remodel.readPlaceFile(".remodel/map.rbxl")

-- In this example, we have a bunch of models stored in
-- ReplicatedStorage.Models. We want to put them into a folder named models,
-- maybe for a tool like Rojo.

local function check(name, checkArr)
	for _, c in pairs(checkArr) do
		if c == name then
			return true
		end
	end
	return false
end

local function isFile(name)
	local success, _ = pcall(function()
		return remodel.isFile(name .. ".rbxmx")
	end)
	if success then
		return success
	else
		return false
	end
end

local Models = game.Workspace
remodel.createDirAll(save)

for _, model in ipairs(Models:GetChildren()) do
	if not check(model.Name, ignore) then
		if isFile(save .. model.Name) and not check(model.Name, restrict) then
			local i = 0
			repeat
				i = i + 1
			until not isFile(save .. model.Name .. i)

			remodel.writeModelFile(save .. model.Name .. i .. ".rbxmx", model)
		else
			remodel.writeModelFile(save .. model.Name .. ".rbxmx", model)
		end
	end
end

-- And that's it!
