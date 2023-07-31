local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component) :: any
local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local Trove = require(ReplicatedStorage.Packages.Trove)

local DELAY_TIME = 4

local NinjaStar = Component.new({
	Tag = "NinjaStar",
})

function NinjaStar:Construct()
	self._trove = Trove.new()
end

function NinjaStar:Start()
    self.Instance.Star.Transparency = 1

	self._trove:Add(Promise.new(function(_, _, onCancel)
		local running = true

		local initialDelay = CollectionService:HasTag(self.Instance, "1") and 1.5 or CollectionService:HasTag(self.Instance, "2") and 1 or error("No 1 or 2 tag")
		print(initialDelay)
        Promise.delay(initialDelay):await()

		while running do
            local clone = self.Instance:Clone()
			clone.Name = "NinjaStarClone"
            clone.Star.Transparency = 0
            CollectionService:RemoveTag(clone, "NinjaStar")
            clone.Star.Anchored = false
            clone.Parent = self.Instance.Parent
            Promise.delay(1):await()
		end

		if onCancel() then
			running = false
		end
	end).cancel)
end

function NinjaStar:Stop()
	self._trove:Clean()
end

return NinjaStar
