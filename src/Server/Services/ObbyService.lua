local Knit = require(game:GetService("ReplicatedStorage").Utils.Knit)

local ObbyService = Knit.CreateService({
	Name = "ObbyService",
	Client = {},
})

function ObbyService:GetCurrentCheckpoint(player: Player)
	local StatsService = Knit.GetService("StatsService")
	local Checkpoints = game:GetService("CollectionService"):GetTagged("Checkpoint")

	local level = StatsService:Get(player, "Level")

	for _, point in pairs(Checkpoints) do
		if point:GetAttribute("Level") == level then
			return point
		end
	end
end

function ObbyService:KnitStart()
	game:GetService("Players").PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(char)
			local point = self:GetCurrentCheckpoint(player)

			char.PrimaryPart:GetPropertyChangedSignal("Position"):Wait()
			char.PrimaryPart.CFrame = point.CFrame * CFrame.new(0, 3, 0)
		end)
	end)
end

function ObbyService:KnitInit() end

return ObbyService
