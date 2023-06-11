local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)

local StatsService = Knit.GetService("StatsService")

local Checkpoint = Component.new({
	Tag = "Checkpoint",
})

function Checkpoint:_onTouched(hit)
	local hum: Humanoid = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end

	local Player = game:GetService("Players"):GetPlayerFromCharacter(hum.Parent)

	if StatsService:Get(Player, "Stage") >= self.Stage then
		return
	end

	StatsService.Client.CheckpointReached:Fire(Player)
	StatsService:Set(Player, "Stage", self.Stage)
end

function Checkpoint:Construct()
	self._trove = Trove.new()

	self.Stage = self.Instance:GetAttribute("Stage")
	if not self.Stage then
		error("Invalid level attribute for " .. self.Instance.Name)
	elseif typeof(self.Stage) ~= "number" then
		error("Stage attribute is a(n) " .. typeof(self.Stage))
	end
	self.Spawn = self.Instance.Spawn
	if self.Stage == 0 then
		return
	end

	self.Touch = self.Instance.Touch

	self._trove:Add(self.Touch.Touched:Connect(function(hit)
		self:_onTouched(hit)
	end))

	self._trove:Add(StatsService.Client.CheckpointReached:Connect(function(plr)
		print(plr)
	end))
end

function Checkpoint:Start() end

function Checkpoint:Stop()
	self._trove:Clean()
end

return Checkpoint
