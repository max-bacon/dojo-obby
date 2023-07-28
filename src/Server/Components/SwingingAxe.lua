local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local SwingingAxe = Component.new({
	Tag = "SwingingAxe",
})

function SwingingAxe:_onTouched(hit: BasePart)
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

function SwingingAxe:_scanForTouchingParts()
	self._trove:Add(RunService.Heartbeat:Connect(function(dt: number)
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

function SwingingAxe:Construct()
	self.OverlapParams = OverlapParams.new()
	self.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	self.OverlapParams.FilterDescendantsInstances = { self.Instance }

	self._trove = Trove.new()

	self:_scanForTouchingParts()
end

function SwingingAxe:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
        local DELTA_ANGLE = 50

        local direction: IntValue = self.Instance:FindFirstChild("Direction")
        assert(direction and direction:IsA("IntValue"))
        local sign = direction.Value
        assert(sign == -1 or sign == 1, "Direction is not -1 or 1")

        self.Instance.PrimaryPart.CFrame = self.Instance.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(sign * DELTA_ANGLE))

        local tween = TweenService:Create(
            self.Instance.PrimaryPart,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            { CFrame = self.Instance.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(-sign * 2 * DELTA_ANGLE)) }
        )
        tween:Play()

        if onCancel() then
			tween:Cancel()
		end
	end).cancel)
end

function SwingingAxe:Stop()
	self._trove:Clean()
end

return SwingingAxe
