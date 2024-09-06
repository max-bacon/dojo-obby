local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local TIME_PER_SPIN = .7

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
		for _, touch in self.Instance.Hitboxes:GetDescendants() do
			if not touch:IsA("BasePart") then
				continue
			end
			for _, part in workspace:GetPartsInPart(touch, self.OverlapParams) do
				self:_onTouched(part)
			end
		end
	end))
end

function SpinningDummy:Construct()
	self.OverlapParams = OverlapParams.new()
	self.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	self.OverlapParams.FilterDescendantsInstances = { self.Instance }

	self._trove = Trove.new()
	self.Active = false

	self.Instance.Outline.Transparency = 1

	self:_scanForTouchingParts()
end

function SpinningDummy:Start()
	

	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
			local spins = math.random(4, 9)
			local sign = math.random() > 0.5 and 1 or -1
			local init = TweenService:Create(
				self.Instance.PrimaryPart,
				TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In),
				{ Orientation = self.Instance.PrimaryPart.Orientation + Vector3.new(0, sign * 30, 0) }
			)
			init:Play()
			init.Completed:Wait()
			Promise.delay(0.2):await()
			local main = TweenService:Create(
				self.Instance.PrimaryPart,
				TweenInfo.new(spins * TIME_PER_SPIN, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{ Orientation = self.Instance.PrimaryPart.Orientation + Vector3.new(0, -sign * (360 * spins + 30), 0) }
			)
			main:Play()
			Promise.delay(0.5):await()
			self.Active = true
			Promise.new(function(resolve)
				main.Completed:Connect(resolve)
				task.wait(spins * TIME_PER_SPIN - 1)
				self.Active = false
			end):await()
			Promise.delay(2):await()
		end
	end).cancel)
end

function SpinningDummy:Stop()
	self._trove:Clean()
end

return SpinningDummy
