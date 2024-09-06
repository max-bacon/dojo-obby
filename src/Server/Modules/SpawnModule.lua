local SpawnModule = {}

local ServerScriptService = game:GetService("ServerScriptService")

local Modules = ServerScriptService.Modules

local StatsModule = require(Modules.StatsModule)

function SpawnModule.spawn(player: Player, char: Model?, awaitChange: boolean?)
	awaitChange = awaitChange or false
	local character = char or player.Character or player.CharacterAdded:Wait()
	assert(character.PrimaryPart)
	
	if awaitChange then
		character.PrimaryPart:GetPropertyChangedSignal("Position"):Wait()
	end
	local checkpoint = game.Workspace.Checkpoints["Checkpoint" .. tostring(StatsModule.get(player, "Stage"))]

	local spawn = checkpoint:FindFirstChild("Spawn") or checkpoint:FindFirstChild("Teleport")
	wait()
	character.PrimaryPart.CFrame = spawn.CFrame * CFrame.new(0, 2, 0)
end

return SpawnModule
