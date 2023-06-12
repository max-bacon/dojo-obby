local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Red = require(ReplicatedStorage.Packages.Red)

local CheckpointReachedNet = Red.Server("CheckpointReached")

local StatsModule = require(ServerScriptService.Modules.StatsModule)

local Checkpoint = Component.new({
	Tag = "Checkpoint",
})

function Checkpoint:_onTouched(hit)
	local hum: Humanoid = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end

	local Player = game:GetService("Players"):GetPlayerFromCharacter(hum.Parent)

	if StatsModule.get(Player, "Stage") >= self.Stage then
		return
	end

	CheckpointReachedNet:Fire(Player)
	StatsModule.set(Player, "Stage", self.Stage)
end

function Checkpoint:Construct()
	self._trove = Trove.new()

	self.Stage = tonumber(self.Instance.Name:sub(11))
	if not self.Stage then
		error("Invalid checkpoint name for " .. self.Instance.Name)
	end
	self.Spawn = self.Instance.Spawn
	if self.Stage == 0 then
		return
	end

	self.Touch = self.Instance.Touch

	self._trove:Add(self.Touch.Touched:Connect(function(hit)
		self:_onTouched(hit)
	end))
end

function Checkpoint:Start() end

function Checkpoint:Stop()
	self._trove:Clean()
end

return Checkpoint
