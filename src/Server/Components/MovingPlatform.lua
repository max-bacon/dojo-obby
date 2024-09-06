local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local MOVE_TIME = 5
local MOVE_DELAY_TIME = 6

local MovingPlatform = Component.new({
	Tag = "MovingPlatform",
})

function MovingPlatform:Construct()
	self._trove = Trove.new()

	self._alignPos = self.Instance.PrimaryPart.AlignPosition
	self._alignOrient = self.Instance.PrimaryPart.AlignOrientation
end

function MovingPlatform:Start()
	--- Run the movement of the platform
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		self._alignOrient.CFrame = self.Instance.PrimaryPart.CFrame

		self._alignPos.Position = self.Instance["1"].Position
		self.Instance.PrimaryPart.Position = self._alignPos.Position

		while running do
			self._alignPos.Position = self.Instance["2"].Position

			task.wait(MOVE_DELAY_TIME)

			self._alignPos.Position = self.Instance["1"].Position

			task.wait(MOVE_DELAY_TIME)
		end
	end).cancel)
end

function MovingPlatform:Stop()
	self._trove:Clean()
end

return MovingPlatform
