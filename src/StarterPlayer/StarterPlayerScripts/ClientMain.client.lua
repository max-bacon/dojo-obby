 --[[
	Initialise main game components, services and modules
--]]

local componentModules = {
	script.Parent:WaitForChild("ClientServices"),
}

for _, instance in pairs (componentModules) do
	if instance:IsA("Folder") then
		for _, moduleScript in pairs(instance:GetChildren()) do
			require(moduleScript).init()
		end
	elseif instance:IsA("ModuleScript") then
		require(instance).init()
	end
end