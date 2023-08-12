local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local MOVE_TIME = 5
local MOVE_DELAY_TIME = 0.5
local CHANGE_VELO_DELAY = 0.5

local MovingPlatform = Component.new({
	Tag = "MovingPlatform",
})

function MovingPlatform:Construct()
	self._trove = Trove.new()

    self._assemblyVeloAlter = Vector3.new()
end

function MovingPlatform:Start()
    --- Run the movement of the platform
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		self.Instance.PrimaryPart.CFrame = CFrame.new(self.Instance["1"].Position)
			* self.Instance.PrimaryPart.CFrame.Rotation

		local firstTween = TweenService:Create(
			self.Instance.PrimaryPart,
			TweenInfo.new(MOVE_TIME, Enum.EasingStyle.Linear),
			{ CFrame = CFrame.new(self.Instance["2"].Position) * self.Instance.PrimaryPart.CFrame.Rotation }
		)

		local secondTween = TweenService:Create(
			self.Instance.PrimaryPart,
			TweenInfo.new(MOVE_TIME, Enum.EasingStyle.Linear),
			{ CFrame = CFrame.new(self.Instance["1"].Position) * self.Instance.PrimaryPart.CFrame.Rotation }
		)

		while running do
			firstTween:Play()
			firstTween.Completed:Wait()

			task.wait(MOVE_DELAY_TIME)

			secondTween:Play()
			secondTween.Completed:Wait()

			task.wait(MOVE_DELAY_TIME)
		end
	end).cancel)

    --- Make it more difficult with random changes
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
            self._assemblyVeloAlter = Vector3.new(math.random(1, 3), 0, math.random(1, 3))
            task.wait(CHANGE_VELO_DELAY)
		end
	end).cancel)

    --- Allow for the player to move with platform
    self._trove:Add(Promise.new(function(_, _, onCancel)
        local lastPos = self.Instance.PrimaryPart.Position

		local con = RunService.Stepped:Connect(function(_, dt)
            local currentPos = self.Instance.PrimaryPart.Position
            local deltaPos = currentPos - lastPos

            self.Instance.PrimaryPart.AssemblyLinearVelocity = deltaPos / dt + self._assemblyVeloAlter

            lastPos = currentPos
		end)

        if onCancel() then
			con:Disconnect()
		end
	end).cancel)
end

function MovingPlatform:Stop()
	self._trove:Clean()
end

return MovingPlatform
