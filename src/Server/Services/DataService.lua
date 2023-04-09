local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Promise = require(Knit.Util.Promise)
local SaveStructure = require(script.Parent.Parent.Modules.SaveStructure)
local ProfileService = require(game:GetService("ServerStorage").Packages.Knit)

local Profiles = {}
local ProfileStore = ProfileService.GetProfileStore("PlayerData", SaveStructure)

local function OnPlayerAdded(player: Player)
	local PlayerProfile = ProfileStore:LoadProfileAsync("Player" .. player.UserId, "ForceLoad")

	if PlayerProfile == nil then
		player:Kick("Unable to load your data. Please rejoin.")
	end

	PlayerProfile:ListenToRelease(function()
		Profiles[player] = nil
	end)
	if not player:IsDescendantOf(Players) then
		PlayerProfile:Release()
	end

	PlayerProfile:Reconcile()
	Profiles[player] = PlayerProfile
end

local function OnPlayerRemoved(player: Player)
	local PlayerProfile = Profiles[player]

	if PlayerProfile then
		PlayerProfile:Release()
	end
end

local DataService = Knit.CreateService({ Name = "DataService" })

function DataService:_getData(player: Player)
	return Promise.new(function(resolve, reject)
		local PlayerProfile = Profiles[player]

		if PlayerProfile then
			return resolve(PlayerProfile.Data)
		end
		return reject("[DataService]: CANNOT GET DATA FROM " .. player.Name .. ".")
	end)
end

function DataService:GetData(player: Player, key: string)
	return Promise.new(function(resolve, reject)
		self:_getData(player)
			:andThen(function(data)
				local value = data[key]

				if value then
					return resolve(value)
				end
				return reject("[DataService]: CANNOT FIND KEY " .. key .. " IN " .. player.Name .. ".")
			end)
			:catch(reject)
	end)
end

function DataService:SaveData(player: Player, key: string, value: any)
	return Promise.new(function(resolve, reject)
		self:GetData(player, key)
			:andThen(function(old)
				if typeof(old) ~= typeof(value) then
					return reject(
						"[DataService]: INVALID SAVE TYPE " .. typeof(value) .. " TO REPLACE " .. typeof(old) .. "."
					)
				end
				return resolve()
			end)
			:catch(reject)
	end)
end

function DataService:Increment(player: Player, key: string, value: number)
	return Promise.new(function(resolve, reject)
		local current = self:GetData(player, key)
			:andThen(function(val)
				return val
			end)
			:catch(reject)

		if typeof(current) ~= "number" then
			return reject("[DataService]: PASSED A(N) " .. typeof(current) .. "INSTEAD OF A number.")
		end

		self:SaveData(player, key, value + current)
			:andThen(function()
				resolve()
			end)
			:catch(reject)
	end)
end

function DataService:KnitStart() end

function DataService:KnitInit()
	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoved)

	game:BindToClose(function()
		for _, player: Player in pairs(Players:GetPlayers()) do
			OnPlayerRemoved(player)
		end
	end)
end

return DataService
