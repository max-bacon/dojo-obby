local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local EmitterMonster = require(script.Parent.EmitterMonster)
local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local FireMonsterObstacle = Component.new({
	Tag = "FireMonsterObstacle",
})

function FireMonsterObstacle:_onTouched(hit: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChild("Humanoid")
	if not hum then
		return
	end
	assert(hum:IsA("Humanoid"))
	if hum.Health > 0 then
		hum:TakeDamage(hum.MaxHealth)
	end
end

function FireMonsterObstacle:_scanForTouchingParts()
	self._trove:Add(RunService.Heartbeat:Connect(function(dt: number)
		if not self.Active then
			return
		end
		for _, touch in self.Instance.Hitboxes:GetDescendants() do
			if not touch:IsA("BasePart") then
				continue
			end
			for _, part in workspace:GetPartsInPart(touch, self.OverlapParams) do
				self:_onTouched(part)
			end
		end
	end))
end

function FireMonsterObstacle:setEmitters(value: boolean)
	for _, monster: Instance in self._monsters do
		local component = EmitterMonster:FromInstance(monster)
		if not component then continue end

		component:setEmitter(value)
	end
end

function FireMonsterObstacle:Construct()
	self.OverlapParams = OverlapParams.new()
	self.OverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	self.OverlapParams.FilterDescendantsInstances = { self.Instance }

	self._trove = Trove.new()
	self.Active = false

	self._activeTime = self.Instance.ActiveTime.Value
	self._restTime = self.Instance.RestTime.Value

	self._monsters = {}
	for _, monster in self.Instance:GetChildren() do
		if CollectionService:HasTag(monster, "EmitterMonster") then
			table.insert(self._monsters, monster)
		end
	end

	self:_scanForTouchingParts()
end

function FireMonsterObstacle:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
			self.Active = true
			self:setEmitters(true)
			Promise.delay(self._activeTime):await()
			self.Active = false
			self:setEmitters(false)
			Promise.delay(self._restTime):await()
		end
	end).cancel)
end

function FireMonsterObstacle:Stop()
	self._trove:Clean()
end

return FireMonsterObstacle
