local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
-- local Promise = require(Knit.Util.Promise)

local Stats = {
	{
		Name = "Level",
		Type = "Int",
	},
	{
		Name = "Time",
		Type = "Int",
	},
}

local StatsService = Knit.CreateService({
	Name = "StatsService",
	Client = {},
})

local function OnPlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	for _, stat in ipairs(Stats) do
        local ins = Instance.new(stat.Type .. "Value")
        ins.Parent = leaderstats
	end
end

function StatsService:KnitStart() end

function StatsService:KnitInit()
	Players.PlayerAdded:Connect(OnPlayerAdded)
end

return StatsService
