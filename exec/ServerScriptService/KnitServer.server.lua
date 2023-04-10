local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Knit = require(ReplicatedStorage.Utils.Knit)

local Services = ServerStorage.Server.Services

local ServerComponents = ServerStorage.Server.Components:GetChildren()
local SharedComponents = ReplicatedStorage.Shared.Components:GetChildren()

Knit.AddServices(Services)

local function load(comp)
	require(comp)
end

Knit.Start()
	:andThen(function()
		for _, comp in pairs(SharedComponents) do
			load(comp)
		end

		for _, comp in pairs(ServerComponents) do
			load(comp)
		end
	end)
	:catch(warn)
