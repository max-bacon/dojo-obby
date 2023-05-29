local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local Players = game:GetService("Players")

local StatsService

local TimeService = Knit.CreateService({
	Name = "TimeService",
})

local Timers = {}

local function OnPlayerAdded(player: Player)
	Timers[player] = Promise.new(function(_, _, onCancel)
		local run = true

		while run do
			task.wait(1)
			StatsService:Increment(player, "Time", 1)
		end

		onCancel(function()
			run = false
		end)
	end)
end

local function OnPlayerRemoving(player: Player)
	Timers[player]:cancel()
	Timers[player] = nil
end

function TimeService:KnitStart()
	StatsService = Knit.GetService("StatsService")

	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoving)
end

function TimeService:KnitInit() end

return TimeService
