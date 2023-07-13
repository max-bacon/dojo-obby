--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)

local SpinningDummy = Component.new({
	Tag = "SpinningDummy",
})

function SpinningDummy:_onTouched(hit: BasePart)
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

function SpinningDummy:_scanForTouchingParts()
	self._trove:Add(RunService.Heartbeat:Connect(function(dt: number)
		if not self.Active then
			return
		end
		for _, part in workspace:GetPartsInPart(self.Touch) do
			self:_onTouched(part)
		end
	end))
end

function SpinningDummy:Construct()
	self._trove = Trove.new()
	self.Touch = self.Instance.Touch
	self.Active = false

	self:_scanForTouchingParts()
end

function SpinningDummy:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
			local spins = math.random(1, 9)
			local init = TweenService:Create(
				self.Instance.PrimaryPart,
				TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{ Orientation = self.Instance.PrimaryPart.Orientation + Vector3.new(0, -30, 0) }
			)
			init:Play()
			print("waiting 1 - ", spins)
			init.Completed:Wait()
			Promise.delay(0.2):await()
			local first = TweenService:Create(
				self.Instance.PrimaryPart,
				TweenInfo.new(spins * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{ Orientation = self.Instance.PrimaryPart.Orientation + Vector3.new(0, 360 * spins + 30, 0) }
			)
			first:Play()
			self.Active = true
			print("waiting 2 - ", spins)
			first.Completed:Wait()
			Promise.delay(2):await()
			self.Active = false
		end
	end).cancel)
end

function SpinningDummy:Stop()
	self._trove:Clean()
end

return SpinningDummy
