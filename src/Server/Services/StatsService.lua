local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

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
		ins.Name = stat.Name
		ins.Parent = leaderstats
	end
end

function StatsService:Set(player: Player, stat: string, new: any)
	local ins = self:GetInstance(player, stat)

	if ins then
		ins.Value = new
	end
end

function StatsService:GetInstance(player: Player, stat: string)
	print(stat)
	local ins = player.leaderstats:FindFirstChild(stat)

	if ins then
		return ins
	else
		error("Could not find stat " .. stat)
	end
end

function StatsService:GetValue(player: Player, stat: string)
	return self:GetInstance(player, stat).Value
end

function StatsService:Increment(player: Player, stat: string, amount: number)
	local ins = self:GetInstance(player, stat)

	if ins:IsA("IntValue") or ins:IsA("NumberValue") then
		ins.Value += amount
	end
end

function StatsService:KnitStart()
	Players.PlayerAdded:Connect(OnPlayerAdded)
end

return StatsService
