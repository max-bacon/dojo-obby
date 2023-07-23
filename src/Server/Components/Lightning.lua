local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Trove = require(ReplicatedStorage.Packages.Trove)

local Lightning = Component.new({
	Tag = "Lightning",
})

function Lightning:_onTouched(hit: BasePart)
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

function Lightning:_scanForTouchingParts()
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

function Lightning:Construct()
	self.OverlapParams = OverlapParams.new()
	self.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	self.OverlapParams.FilterDescendantsInstances = { self.Instance.Parent }

    self.Bounds = self.Instance.Parent.Bounds:GetChildren() :: {BasePart}

	local totalArea = 0
    self.Weights = {} :: {number}
    for i, p in self.Bounds do
		self.Weights[i] = p.Size.X * p.Size.Z
        totalArea += self.Weights[i]
    end
	for i, p in self.Bounds do
        self.Weights[i] /= totalArea
    end

	self._trove = Trove.new()

	self:_scanForTouchingParts()
end

function Lightning:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
			local randomNumberForPart = math.random()
			local totalRandomness = 1
			local goalPart: BasePart
			for i, p in self.Bounds do
				totalRandomness -= self.Weights[i]
				if randomNumberForPart > totalRandomness then
					goalPart = p
					break
				end
			end
			
			local xzPartVector = Vector2.new(goalPart.Position.X, goalPart.Position.Z)
			local xzSizeVector = Vector2.new(goalPart.Size.X, goalPart.Size.Z)
			local yAngle = goalPart.Orientation.Y -- Degrees
			local xzGoalUnrotatedVector = Vector2.new(math.random(), math.random()) * xzSizeVector -.5 * xzSizeVector + xzPartVector
			local diffVector = xzGoalUnrotatedVector - xzPartVector

			local beta = math.rad(yAngle)
			local xzGoal = xzPartVector + Vector2.new(math.cos(beta) * diffVector.X - math.sin(beta) * diffVector.Y, math.cos(beta) * diffVector.Y + math.sin(beta) * diffVector.X)

			local goal = Vector3.new(xzGoal.X, goalPart.Position.Y, xzGoal.Y)

			local main = TweenService:Create(
				self.Instance.PrimaryPart,
				TweenInfo.new(.1 * (Vector2.new(self.Instance.PrimaryPart.Position.X, self.Instance.PrimaryPart.Position.Z) - xzGoal).Magnitude, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut),
				{ CFrame = CFrame.new(goal) * CFrame.Angles(0, math.rad(25), math.rad(-90))}
			)
			main:Play()
			main.Completed:Wait()

			Promise.delay(3):await()
		end
	end).cancel)
end

function Lightning:Stop()
	self._trove:Clean()
end

return Lightning
