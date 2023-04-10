local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Utils.Knit)
local Component = require(ReplicatedStorage.Utils.Component)
local Trove = require(ReplicatedStorage.Utils.Trove)

local StatsService = Knit.GetService("StatsService")

local Checkpoint = Component.new({
	Tag = "Checkpoint",
	Ancestors = { workspace },
})

function Checkpoint:_onTouched(hit)
	local hum: Humanoid = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end

	local Player = game:GetService("Players"):GetPlayerFromCharacter(hum.Parent)

	if StatsService:Get(Player, "Level") == self.Level then
		return
	end

	StatsService:Set(Player, "Level", self.Level)
end

function Checkpoint:Construct()
	self._trove = Trove.new()

	self.Level = self.Instance:GetAttribute("Level")
	if not self.Level then
		error("Invalid level attribute for " .. self.Instance.Name)
	elseif typeof(self.Level) ~= "number" then
		error("Level attribute is a(n) " .. typeof(self.Level))
	end

	self._trove:Add(self.Instance.Touched:Connect(function(hit)
		self:_onTouched(hit)
	end))
end

function Checkpoint:Start() end

function Checkpoint:Stop()
	self._trove:Clean()
end

return Checkpoint
