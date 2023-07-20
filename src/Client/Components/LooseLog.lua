local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)
local Component = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Component"))
local Trove = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Trove"))

local LooseLog = Component.new({
	Tag = "LooseLog",
})

function LooseLog:_onTouched(hit: BasePart)
	if self._touchDebounce then return end
    self._touchDebounce = true

    local rotationAmount = 5

    local randNum = math.random()
    local vectorAdjustment = randNum > .667 and Vector3.new(rotationAmount, 0, 0) or randNum > .333 and Vector3.new(0, rotationAmount, 0) or Vector3.new(0, 0, rotationAmount)
    local sign = randNum > 0.5 and 1 or -1


    self.Instance.Orientation += sign * vectorAdjustment
    for i = 2, 15 do
        Promise.delay(.05):await()
        local mult = i % 2 == 0 and -1 or 1
        
        self.Instance.Orientation += 2 * mult * sign * vectorAdjustment
    end
    self.Instance.Orientation += sign * vectorAdjustment

    self.Instance.CanCollide = false

    local clone = self.Instance:Clone()
    clone:RemoveTag("LooseLog")
    clone.CanCollide = false
    clone.Anchored = false
    clone.Parent = self.Instance.Parent

    self.Instance.Transparency = 1

    Promise.delay(4):await()
    clone:Destroy()

    self.Instance.Transparency = 0
    self.Instance.CanCollide = true

    self._touchDebounce = false
end

function LooseLog:_initializeTouchedConnections()
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

function LooseLog:Construct()
	self._trove = Trove.new()

    self._touchDebounce = false

	self:_initializeTouchedConnections()
end

function LooseLog:Start() 
end

function LooseLog:Stop()
	self._trove:Clean()
end

return LooseLog
