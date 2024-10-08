--@script
local CollectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Red = require(Packages.Red)

local Remotes = Red.Server("Network")

local Modules = ServerScriptService.Modules

local StatsModule = require(Modules.StatsModule)
local SpawnModule = require(Modules.SpawnModule)
local PurchaseModule = require(Modules.PurchaseModule)
local ComponentTimingModule = require(Modules.ComponentTimingModule)

local Components = {}

for _, c in ServerScriptService.Components:GetChildren() do
	Components[c.Name] = require(c) :: any
end

PhysicsService:RegisterCollisionGroup("PlayerCharacter")
PhysicsService:CollisionGroupSetCollidable("PlayerCharacter", "PlayerCharacter", false)

Players.PlayerAdded:Connect(function(player: Player)
	StatsModule.initialize(player)

	player.CharacterAdded:Connect(function(character: Model)
		SpawnModule.spawn(player, character, true)
		for _, p in character:GetChildren() do
			if p:IsA("BasePart") then
				p.CollisionGroup = "PlayerCharacter"
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player: Player)
	StatsModule.clean(player)
end)

ComponentTimingModule.initialize(Components)
