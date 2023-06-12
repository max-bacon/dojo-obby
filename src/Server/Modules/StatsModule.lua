--!strict

local StatsModule = {}

export type StatsArray = {
	Stage: IntValue,
	Wins: IntValue,
}

local Stats: { [Player]: StatsArray } = {}

function StatsModule.get(player: Player, stat: string): any
	local data = Stats[player]

	return data[stat].Value
end

function StatsModule.set(player: Player, stat: string, value: any)
	local data = Stats[player]

	data[stat].Value = value
end

function StatsModule.initialize(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local level = Instance.new("IntValue")
	level.Name = "Stage"
	level.Value = 0
	level.Parent = leaderstats

	local wins = Instance.new("IntValue")
	level.Name = "Wins"
	wins.Value = 0
	wins.Parent = leaderstats

	Stats[player] = {
		Stage = level,
		Wins = wins,
	}
end

function StatsModule.clean(player: Player)
	Stats[player] = nil
end

return StatsModule