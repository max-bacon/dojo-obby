--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)

local KillBrick = Component.new({
	Tag = "KillBrick",
})

function KillBrick:_onTouched(hit)
	local hum: Humanoid = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end

	if hum.Health > 0 then
		hum:TakeDamage(hum.MaxHealth)
	end
end

function KillBrick:_touchedLogic()
	if self.Instance:IsA("BasePart") then
		self._trove:Add(self.Instance.Touched:Connect(function(hit)
			self:_onTouched(hit)
		end))
	end

	for _, p in self.Instance:GetDescendants() do
		if p:IsA("BasePart") then
			self._trove:Add(p.Touched:Connect(function(hit)
				self:_onTouched(hit)
			end))
		end
	end
end

function KillBrick:Construct()
	self._trove = Trove.new()

	self:_touchedLogic()
end

function KillBrick:Start() end

function KillBrick:Stop()
	self._trove:Clean()
end

return KillBrick
