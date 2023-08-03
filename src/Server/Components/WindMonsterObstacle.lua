local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local EmitterMonster = require(script.Parent.EmitterMonster)
local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local WindMonsterWall = Component.new({
	Tag = "WindMonsterWall",
})

function WindMonsterWall:_onTouched(hit: BasePart, touch: BasePart)
	assert(hit.Parent)
	local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
    local char = hum.Parent
    assert(char)

    local player = Players:GetPlayerFromCharacter(char)
    assert(player)

    local hrp = char:FindFirstChild("HumanoidRootPart")
    assert(hrp and hrp:IsA("BasePart"))
    if hrp:FindFirstChild("Blow") then
        return
    end

    hum.Sit = true
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = hrp

    local linearVelo = Instance.new("LinearVelocity")
    linearVelo.Name = "Blow"
    linearVelo.MaxForce = 100000
    linearVelo.Attachment0 = attachment
    linearVelo.VectorVelocity = -touch.CFrame.LookVector * 100
    linearVelo.Parent = hrp
    task.wait(.1)
    linearVelo.Enabled = false

    task.wait(1)
    linearVelo:Destroy()
    attachment:Destroy()
end

function WindMonsterWall:_scanForTouchingParts()
	self._trove:Add(RunService.Heartbeat:Connect(function(dt: number)
		if not self.Active then
			return
		end
		for _, touch: Instance in self.Instance.Hitboxes:GetDescendants() do
			if not touch:IsA("BasePart") then
				continue
			end
			for _, part in workspace:GetPartsInPart(touch, self.OverlapParams) do
				self:_onTouched(part, touch)
			end
		end
	end))
end

function WindMonsterWall:setEmitters(value: boolean)
	for _, monster: Instance in self._monsters do
		local component = EmitterMonster:FromInstance(monster)
		if not component then continue end

		component:setEmitter(value)
	end
end

function WindMonsterWall:Construct()
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

    self._blowing = {}

	self:_scanForTouchingParts()
end

function WindMonsterWall:Start()
	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		if onCancel() then
			running = false
		end

		while running do
			self.Active = true
			self:setEmitters(true)
			Promise.delay(5):await()
			self.Active = false
			self:setEmitters(false)
			Promise.delay(3):await()
		end
	end).cancel)
end

function WindMonsterWall:Stop()
	self._trove:Clean()
end

return WindMonsterWall
