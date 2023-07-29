local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local SwingingAxe = Component.new({
	Tag = "SwingingAxe",
})

function SwingingAxe:Construct()
	self._trove = Trove.new()
end

function SwingingAxe:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
        local DELTA_ANGLE = 50

        local sign = CollectionService:HasTag(self.Instance, "Left") and 1 or CollectionService:HasTag(self.Instance, "Right") and -1 or error("No left or right tag")

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
