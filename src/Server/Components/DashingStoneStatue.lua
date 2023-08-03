local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local EmitterMonster = require(script.Parent.EmitterMonster)
local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local ROTATION_TIME = .3
local DASH_TIME = 1

local DashingStoneStatue = Component.new({
	Tag = "DashingStoneStatue",
})

function DashingStoneStatue:_onTouched(hit: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end
	assert(hum:IsA("Humanoid"))
	if hum.Health > 0 then
		hum:TakeDamage(hum.MaxHealth)
	end
end

function DashingStoneStatue:Construct()
	self._trove = Trove.new()

	self._trove:Add(self.Instance.StoneStatue.Hitbox.Touched:Connect(function(hit)
		self:_onTouched(hit)
	end))
end

function DashingStoneStatue:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		local startCFrame = self.Instance.StoneStatue.PrimaryPart.CFrame
		local nextStopCFrame = CFrame.new(self.Instance["2"].Position) * startCFrame.Rotation
		local firstRotationCFrame = nextStopCFrame * CFrame.Angles(math.rad(180), 0, 0)
		local lastStopCFrame = CFrame.new(self.Instance["1"].Position)
			* CFrame.Angles(0, math.rad(180), 0)
			* startCFrame.Rotation

		local forwardTween = TweenService:Create(
			self.Instance.StoneStatue.PrimaryPart,
			TweenInfo.new(DASH_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ CFrame = nextStopCFrame }
		)

		local rotateTween1 = TweenService:Create(
			self.Instance.StoneStatue.PrimaryPart,
			TweenInfo.new(ROTATION_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ CFrame = firstRotationCFrame }
		)

		local backTween = TweenService:Create(
			self.Instance.StoneStatue.PrimaryPart,
			TweenInfo.new(DASH_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ CFrame = lastStopCFrame }
		)

		local rotateTween2 = TweenService:Create(
			self.Instance.StoneStatue.PrimaryPart,
			TweenInfo.new(ROTATION_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
			{ CFrame = startCFrame }
		)

		while running do
			forwardTween:Play()
			forwardTween.Completed:Wait()

			rotateTween1:Play()
			rotateTween1.Completed:Wait()

			backTween:Play()
			backTween.Completed:Wait()

			rotateTween2:Play()
			rotateTween2.Completed:Wait()
		end
	end).cancel)
end

function DashingStoneStatue:Stop()
	self._trove:Clean()
end

return DashingStoneStatue
