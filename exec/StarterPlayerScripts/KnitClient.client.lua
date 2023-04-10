local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Utils.Knit)

local Controllers = ReplicatedStorage.Client.Controllers

local ClientComponents = ReplicatedStorage.Client.Components:GetChildren()

Knit.AddControllers(Controllers)

local function load(comp)
	require(comp)
end

Knit.Start()
	:andThen(function()
		for _, comp in pairs(ClientComponents) do
			load(comp)
		end
	end)
	:catch(warn)
