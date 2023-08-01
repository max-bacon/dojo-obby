local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local Dynamite = Component.new({
	Tag = "Dynamite",
})

function Dynamite:_kill(char: Model)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	assert(hrp and hrp:IsA("BasePart"))

	local explosionDeath = Instance.new("Explosion")
	explosionDeath.DestroyJointRadiusPercent = 1
	explosionDeath.BlastRadius = 3
	explosionDeath.BlastPressure = 100000
	explosionDeath.Visible = false
	explosionDeath.Position = hrp.Position
	explosionDeath.Parent = char:FindFirstChild("HumanoidRootPart")

	local explosionVisual = Instance.new("Explosion")
	explosionVisual.DestroyJointRadiusPercent = 0
	explosionVisual.BlastRadius = 0
	explosionVisual.BlastPressure = 0

	local sound: Sound = self.Instance.ExplosionSound
	local originalVolume = sound.Volume
	assert(sound and sound:IsA("Sound"))
	
	for _, part: BasePart in self.Instance.ExplosionSources:GetChildren() do
		assert(part:IsA("BasePart"))
		local explosionClone = explosionVisual:Clone()
		explosionClone.Position = part.Position
		explosionClone.Parent = part

		local soundClone: Sound = part:FindFirstChild("ExplosionSound") :: Sound or sound:Clone()
		soundClone.Parent = part
		assert(soundClone and soundClone:IsA("Sound"))

		local soundTween = TweenService:Create(soundClone, TweenInfo.new(sound.TimeLength, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Volume = 0})
		soundTween:Play()
		soundClone:Play()

		soundTween.Completed:Connect(function()
			soundClone.Volume = originalVolume
		end)
	end
end

function Dynamite:_onTouched(hit: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end
	assert(hum:IsA("Humanoid"))
	assert(hum.Parent and hum.Parent:IsA("Model"))
	local char: Model = hum.Parent
	

	if hum.Health > 0 then
		self:_kill(char)
	end
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

	self:_initializeTouchedConnections()
end

function Dynamite:Start() end

function Dynamite:Stop()
	self._trove:Clean()
end

return Dynamite
