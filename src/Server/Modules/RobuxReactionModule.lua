local RobuxReactionModule = {}

local ServerScriptService = game:GetService("ServerScriptService")

local SpawnModule = require(script.Parent.SpawnModule)
local StatsModule = require(script.Parent.StatsModule)

RobuxReactionModule.SkipStage = function(player: Player): boolean
	if StatsModule.get(player, "Stage") >= #workspace.Checkpoints:GetChildren() - 1 then
		return false
	end
	StatsModule.increment(player, "Stage")
	SpawnModule.spawn(player)

	return true
end

RobuxReactionModule.Sensei = function(player: Player)
	return true
end

return RobuxReactionModule
