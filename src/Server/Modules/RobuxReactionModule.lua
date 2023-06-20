local RobuxReactionModule = {}

local ServerScriptService = game:GetService("ServerScriptService")

local SpawnModule = require(script.Parent.SpawnModule)
local StatsModule = require(script.Parent.StatsModule)

RobuxReactionModule.SkipStage = function(player: Player)
    if StatsModule.get(player, "Stage") >= #workspace.Checkpoints:GetChildren() - 1 then
        return
    end
    StatsModule.increment(player, "Stage")
    SpawnModule.spawn(player)
end

RobuxReactionModule.Sensei = function(player: Player)
    
end

return RobuxReactionModule