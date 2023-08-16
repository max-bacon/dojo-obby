local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Shake = require(ReplicatedStorage.Packages.Shake)
local Component = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Component")) :: any
local Trove = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Trove"))

local Dynamite = Component.new({
	Tag = "Dynamite",
})

function Dynamite:_onTouched(hit: BasePart)
	if hit.Parent ~= Players.LocalPlayer.Character then
		return
	end
	if self._touchDebounce then
		return
	end

	self._touchDebounce = true

	local camera = workspace.CurrentCamera

	self._shake:Start()
	self._shake:BindToRenderStep(Shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(pos, rot, isDone)
		camera.CFrame *= CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)
	end)

	self._touchDebounce = false
end

function Dynamite:_initializeTouchedConnections()
	for _, p in self.Instance.Touch:GetChildren() do
		if p:IsA("BasePart") then
			self._trove:Add(p.Touched:Connect(function(hit)
				self:_onTouched(hit)
			end))
		end
	end
end

function Dynamite:Construct()
	self._trove = Trove.new()

	self._touchDebounce = false

	self:_initializeTouchedConnections()

	self._shake = Shake.new()
	self._shake.FadeInTime = 0
	self._shake.FadeOutTime = 3
	self._shake.Frequency = 0.2
	self._shake.Amplitude = 0.6
	self._shake.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
end

function Dynamite:Start() end

function Dynamite:Stop()
	self._trove:Clean()
end

return Dynamite
