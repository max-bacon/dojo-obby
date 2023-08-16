local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local NinjaStarTool = Component.new({
	Tag = "NinjaStarTool",
})

function NinjaStarTool:_onTouched(hit: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end
	assert(hum:IsA("Humanoid"))

	if hum.Health > 0 then
		hum:TakeDamage(hum.MaxHealth)

		if not self.Instance:FindFirstChild("KillSound") then
			print(self.Instance:GetChildren(), self.Instance.Name)
			return
		end
		print("sound")
		self.Instance.KillSound:Play()
	end
end

function NinjaStarTool:_initializeTouchedConnections()
	for _, p in self.Instance:GetDescendants() do
		if p:IsA("BasePart") then
			self._trove:Add(p.Touched:Connect(function(hit)
				self:_onTouched(hit)
			end))
		end
	end
end

function NinjaStarTool:Construct()
	self._trove = Trove.new()

	self:_initializeTouchedConnections()
end

function NinjaStarTool:Start() end

function NinjaStarTool:Stop()
	self._trove:Clean()
end

return NinjaStarTool
