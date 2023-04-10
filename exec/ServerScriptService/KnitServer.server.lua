local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Services = ServerStorage.Server.Services

local ServerComponents = ServerStorage.Server.Components:GetChildren()
local SharedComponents = ReplicatedStorage.Shared.Components:GetChildren()

Knit.AddServices(Services)

Knit.Start()
	:andThen(function()
		for _, comp in pairs({ table.unpack(ServerComponents), table.unpack(SharedComponents) }) do
			require(comp)
		end
	end)
	:catch(warn)
