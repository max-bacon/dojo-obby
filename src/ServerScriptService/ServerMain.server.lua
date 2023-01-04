--[[
	Initialise main game components, services and modules
--]]
-- HI VALT WAS HERE
--Services
local ServerStorage = game:GetService("ServerStorage")

--Variables
local GameVariables = {
	gameServices = {},
}

-- Type in any Modules where it should be required(), either a ModuleScript or a Folder containing ModuleScripts.
local componentModules = {
	ServerStorage.ModuleScripts.StateLogic,
}

--Functions
function initializeModule(moduleScript)
	-- {Module = require()} is used instead of [GameService[] = require()] for meta-table and registery in General-Handler usages later.
	local success,message = pcall(function()
		GameVariables.gameServices[moduleScript.Name] = {module = require(moduleScript)}
		GameVariables.gameServices[moduleScript.Name].module.init(GameVariables)
	end)
	if not success then
		-- This is for In-Game Debugger, should be changed in future for greater extended usages.
		warn(message)
	end
end

--Methods
for _, instance in pairs (componentModules) do
	if instance:IsA("Folder") then
		for _, moduleScript in pairs (instance:GetChildren()) do
			initializeModule(moduleScript)
		end
	elseif instance:IsA("ModuleScript") then
		initializeModule(instance)
	end
end