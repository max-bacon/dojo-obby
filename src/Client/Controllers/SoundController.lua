local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Utils.Knit)

local SoundController = Knit.CreateController({ Name = "SoundController" })
local TweenService = game:GetService("TweenService")

local StatsService

SoundController.Sounds = require(ReplicatedStorage.Shared.Modules.Sounds)

function SoundController:PrepareSound(name: string, props)
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.SoundId = SoundController.Sounds[name]

	for prop, val in pairs(props) do
		sound[prop] = val
	end

	if not sound.Parent then
		sound.Parent = game:GetService("SoundService")
	end

	return sound
end

function SoundController:CheckpointSound()
	task.wait(1)

	local sound = self:PrepareSound("Checkpoint", {
		TimePosition = 9,
		Volume = 0,
	})

	local Tween = TweenService:Create(
		sound,
		TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true),
		{ Volume = 1 }
	)
	Tween:Play()
	sound:Play()
	local a = StatsService.CheckpointReached:Connect(function()
		sound:Stop()
		Tween:Cancel()
		sound:Destroy()
	end)
	task.wait(6)
	sound:Stop()
	sound:Destroy()
	a:Disconnect()
end

function SoundController:KnitStart()
	StatsService = Knit.GetService("StatsService")
	StatsService.CheckpointReached:Connect(function()
		self:CheckpointSound()
	end)
end

function SoundController:KnitInit() end

return SoundController
