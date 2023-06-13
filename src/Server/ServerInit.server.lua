local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Modules = ServerScriptService.Modules

local StatsModule = require(Modules.StatsModule)
local SpawnModule = require(Modules.SpawnModule)

local Components = {}

for _, c in ServerScriptService.Components:GetChildren() do
	Components[c.Name] = require(c)
end

Players.PlayerAdded:Connect(function(player: Player)
	StatsModule.initialize(player)

    player.CharacterAdded:Connect(function(character: Model)
        SpawnModule.spawn(player, character)
    end)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	StatsModule.clean(player)
end)
