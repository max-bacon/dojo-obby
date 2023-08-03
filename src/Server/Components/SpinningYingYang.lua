local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local TIME_PER_SPIN = 1

local SpinningYingYang = Component.new({
	Tag = "SpinningYingYang",
})

function SpinningYingYang:Construct()
	self._trove = Trove.new()
end

function SpinningYingYang:Start()
	local directionSign = CollectionService:HasTag(self.Instance, "1") and 1
		or CollectionService:HasTag(self.Instance, "2") and -1
		or error("No 1 or 2 tag")

	local spinTween = TweenService:Create(
		self.Instance,
		TweenInfo.new(TIME_PER_SPIN, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
		{ Rotation = directionSign * Vector3.new(0, 360, 0) }
	)
	spinTween:Play()

	self._trove:Add(function()
		spinTween:Cancel()
	end)
end

function SpinningYingYang:Stop()
	self._trove:Clean()
end

return SpinningYingYang
