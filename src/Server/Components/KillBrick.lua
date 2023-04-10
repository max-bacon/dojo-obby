local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Utils.Component)
local Trove = require(ReplicatedStorage.Utils.Trove)

local KillBrick = Component.new({
	Tag = "KillBrick",
	Ancestors = { workspace },
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

function KillBrick:Construct()
	self._trove = Trove.new()
	self._trove:Add(self.Instance.Touched:Connect(function(hit)
		self:_onTouched(hit)
	end))
end

function KillBrick:Start() end

function KillBrick:Stop()
	self._trove:Clean()
end

return KillBrick
