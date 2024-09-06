local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local EmitterMonster = Component.new({
	Tag = "EmitterMonster",
})

function EmitterMonster:setEmitter(value: boolean)
	for _, e: ParticleEmitter in self._emitters do
		e.Enabled = value
	end
end

function EmitterMonster:Construct()
	self._trove = Trove.new()

	self._emitters = {} :: {ParticleEmitter}
	for _, emitterSource in self.Instance:GetChildren() do
		if not (emitterSource.Name == "EmitterSource") then
			continue
		end

		for _, emitter in emitterSource:GetChildren() do
			if emitter:IsA("ParticleEmitter") then
				table.insert(self._emitters, emitter)
			elseif emitter:IsA("Attachment") then
				for _, emitter2 in emitter:GetChildren() do
					table.insert(self._emitters, emitter2)
				end
			end

			
		end
	end
end

function EmitterMonster:Start() end

function EmitterMonster:Stop()
	self._trove:Clean()
end

return EmitterMonster
