local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Utils.Fusion)

local Value = Fusion.Value
local New, Children = Fusion.New, Fusion.Children

local FlyingKatana = require(script.FlyingKatana)
local CheckpointLabel = require(script.CheckpointLabel)

local Time = 5
local delayTime = 0.8

local function newLevel(props)
	local katanaXPos = Value(Vector2.new())
	local level = New("Frame")({
		Name = "NewLevel",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			FlyingKatana({
				Event = props.Event,
				Position = katanaXPos,
				Time = Time,
			}),
			CheckpointLabel({
				Event = props.Event,
				KatanaXPos = katanaXPos,
				Time = Time,
				DelayTime = delayTime,
			}),
		},
	})

	return level
end

return newLevel
