local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local ANGULAR_VELO = Vector3.new(0, 5, 0)

local SpinningYingYang = Component.new({
	Tag = "SpinningYingYang",
})

function SpinningYingYang:Construct()
	self._trove = Trove.new()
	self._alignPosition = self.Instance.AlignPosition
	self._angVelo = self.Instance.AngularVelocity
end

function SpinningYingYang:Start()
	local directionSign = CollectionService:HasTag(self.Instance, "1") and 1
		or CollectionService:HasTag(self.Instance, "2") and -1
		or error("No 1 or 2 tag")


	self._alignPosition.Position = self.Instance.Position

	self._angVelo.AngularVelocity = ANGULAR_VELO * directionSign
end

function SpinningYingYang:Stop()
	self._trove:Clean()
end

return SpinningYingYang
