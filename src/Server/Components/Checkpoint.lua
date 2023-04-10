local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.Trove)

local Checkpoint = {}
Checkpoint.__index = Checkpoint
Checkpoint.Tag = "Checkpoint"

function Checkpoint.new(instance)
    local self = setmetatable({}, Checkpoint)
    self._trove = Trove.new()
    self.Instance = instance
    return self
end

function Checkpoint:Destroy()
    self._trove:Clean()
end

return Checkpoint
