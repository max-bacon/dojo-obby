local Knit = require(game:GetService("ReplicatedStorage").Utils.Knit)

local CheckpointController = Knit.CreateController({ Name = "CheckpointController" })

function CheckpointController:KnitStart()
	local StatsService = Knit.GetService("StatsService")
	--local UIController = Knit.GetController("UIController")
	StatsService.CheckpointReached:Connect(function()
		print("test")
        --UIController:Play("Checkpoint")
	end)
end

function CheckpointController:KnitInit() end

return CheckpointController
