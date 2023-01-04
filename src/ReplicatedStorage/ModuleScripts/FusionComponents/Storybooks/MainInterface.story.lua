return function(target)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local componentToDisplay = require(ReplicatedStorage.ModuleScripts.FusionComponents.MainInterface)
	local mounted = componentToDisplay(target)

	return function()
		mounted:Destroy()
	end
end