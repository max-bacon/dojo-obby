local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)
local SaveStructure = require(script.Parent.Parent.Modules.SaveStructure)
local ProfileService = require(game:GetService("ServerStorage").Packages.ProfileService)

local Profiles = {}
local ProfileStore = ProfileService.GetProfileStore("PlayerData", SaveStructure)

local DataService = Knit.CreateService({ Name = "DataService" })

local function LoadProfilePromise(player: Player)
	return Promise.new(function(resolve, reject)
		local PlayerProfile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")

		if PlayerProfile == nil then
			player:Kick("Unable to load your data. Please rejoin.")
			reject("Could not load data for " .. player.Name)
		end

		resolve(PlayerProfile)
	end)
end

local function OnPlayerAdded(player: Player)
	LoadProfilePromise(player):andThen(function(PlayerProfile)
		PlayerProfile:ListenToRelease(function()
			Profiles[player] = nil
		end)
		if not player:IsDescendantOf(Players) then
			PlayerProfile:Release()
			return
		end

		PlayerProfile:Reconcile()
		Profiles[player] = PlayerProfile
	end)
end

local function OnPlayerRemoving(player: Player)
	local PlayerProfile = Profiles[player]

	if PlayerProfile then
		PlayerProfile:Release()
	end
end

function DataService:GetDataArray(player: Player)
	local PlayerProfile = Profiles[player]

	if PlayerProfile then
		return PlayerProfile.Data
	end
	error("[DataService]: CANNOT GET DATA FROM " .. player.Name .. ".")
end

function DataService:GetData(player: Player, key: string)
	local data = self:GetDataArray(player)

	local value = data[key]

	if value then
		return value
	end
	error("[DataService]: CANNOT FIND KEY " .. key .. " IN " .. player.Name .. ".")
end

function DataService:SaveData(player: Player, key: string, value: any)
	local old = self:GetData(player, key)
	if typeof(old) ~= typeof(value) then
		return error("[DataService]: INVALID SAVE TYPE " .. typeof(value) .. " TO REPLACE " .. typeof(old) .. ".")
	end

	Profiles[player][key] = value
end

function DataService:Increment(player: Player, key: string, value: number)
	local current = self:GetData(player, key)

	if typeof(current) ~= "number" then
		error("[DataService]: PASSED A(N) " .. typeof(current) .. "INSTEAD OF A number.")
	end

	self:SaveData(player, key, value + current)
end

function DataService:IsValidKey(check: string)
	for _, key in pairs(SaveStructure) do
		if key == check then
			return true
		end
	end
	return false
end

function DataService:KnitStart()
	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoving)

	game:BindToClose(function()
		for _, player: Player in pairs(Players:GetPlayers()) do
			OnPlayerRemoving(player)
		end
	end)
end

return DataService
