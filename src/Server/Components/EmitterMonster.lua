local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local EmitterMonster = Component.new({
	Tag = "EmitterMonster",
})

function EmitterMonster:setEmitter(value: boolean)
	self._emitter.Enabled = value
end

function EmitterMonster:Construct()
	self._trove = Trove.new()

	local emitterSource: Instance = self.Instance:FindFirstChild("EmitterSource")
	assert(emitterSource)
	self._emitter = emitterSource:FindFirstChild("ParticleEmitter")
	assert(self._emitter and self._emitter:IsA("ParticleEmitter"))
end

function EmitterMonster:Start() end

function EmitterMonster:Stop()
	self._trove:Clean()
end

return EmitterMonster
