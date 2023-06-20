local SpawnModule = {}

local ServerScriptService = game:GetService("ServerScriptService")

local Modules = ServerScriptService.Modules

local StatsModule = require(Modules.StatsModule)

function SpawnModule.spawn(player: Player, char: Model?)
    local character = char or player.Character or player.CharacterAdded:Wait()
    assert(character.PrimaryPart)
    character.PrimaryPart:GetPropertyChangedSignal("Position"):Wait()

    local checkpoint = game.Workspace.Checkpoints["Checkpoint"..tostring(StatsModule.get(player, "Stage"))]
    local spawn = checkpoint.Spawn

    character.PrimaryPart.CFrame = spawn.CFrame * CFrame.new(0,3,0)
end


return SpawnModule
