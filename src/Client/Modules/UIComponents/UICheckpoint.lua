local UIComponent = require(script.Parent.Parent.UIComponent)
local UICheckpoint = {}
UICheckpoint.__index = UICheckpoint
setmetatable(UICheckpoint, UIComponent)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Utils.Trove)

function UICheckpoint.new()
	local self = setmetatable({}, UICheckpoint)
	self._trove = Trove.new()
	self:Init()

	return self
end

function UICheckpoint:Init() end

function UICheckpoint:Destroy()
	self._trove:Destroy()
end

return UICheckpoint
