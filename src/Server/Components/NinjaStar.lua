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

function NinjaStar:Fire()
	local clone = self.Instance:Clone()
	clone.Name = "NinjaStarClone"
	clone.Star.Transparency = 0
	CollectionService:RemoveTag(clone, "NinjaStar")
	clone.Star.Anchored = false
	clone.Parent = self.Instance.Parent
end

function NinjaStar:Construct()
	self._trove = Trove.new()

	self.Instance.Star.Transparency = 1
end

function NinjaStar:Start()
    
end

function NinjaStar:Stop()
	self._trove:Clean()
end

return NinjaStar
