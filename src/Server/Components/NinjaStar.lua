local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local NinjaStar = Component.new({
	Tag = "NinjaStar",
})

function NinjaStar:Construct()
	self._trove = Trove.new()
end

function NinjaStar:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
        self.Instance.PrimaryPart.CFrame = self.Instance.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(DELTA_ANGLE))

        local tween = TweenService:Create(
            self.Instance.PrimaryPart,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            { CFrame = self.Instance.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(DELTA_ANGLE)) }
        )
        tween:Play()

        if onCancel() then
			tween:Cancel()
		end
	end).cancel)
end

function NinjaStar:Stop()
	self._trove:Clean()
end

return NinjaStar
