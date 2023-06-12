local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Red = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Red"))

local Interface = require(ReplicatedStorage.Interface)
local FusionMaterial = ReplicatedStorage:WaitForChild("FusionMaterial")

local CheckpointReached = Red.Client("CheckpointReached")

local State = require(ReplicatedStorage:WaitForChild("State"))()

local UIComponents = {}
for _, mod in FusionMaterial:GetChildren() do
	UIComponents[mod.Name] = mod
end

local UI = Interface(State, UIComponents)
local CheckpointNotification = UI.CheckpointNotification