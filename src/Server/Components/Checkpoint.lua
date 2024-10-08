local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local StatsModule = require(ServerScriptService.Modules.StatsModule)

local Checkpoint = Component.new({
	Tag = "Checkpoint",
})

function Checkpoint:_onTouched(hit: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end

	if not (hum.Health > 0) then
		return
	end
	
	local Player = game:GetService("Players"):GetPlayerFromCharacter(hum.Parent)
	
	if StatsModule.get(Player, "Stage") >= self.Stage then
		return
	end

	StatsModule.set(Player, "Stage", self.Stage)
end

function Checkpoint:Construct()
	self._trove = Trove.new()

	self.Stage = tonumber(self.Instance.Name:sub(11))
	self.Spawn = self.Instance:FindFirstChild("Spawn") or self.Instance:FindFirstChild("Teleport")
	self.Teleport = self.Instance:FindFirstChild("Teleport")
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
