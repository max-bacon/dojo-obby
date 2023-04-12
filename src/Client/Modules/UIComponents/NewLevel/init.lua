local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Utils.Fusion)
local BezierTween = require(ReplicatedStorage.Utils.BezierTween)
local Images = require(ReplicatedStorage.Shared.Modules.Images)

local Value, Observer, Computed, ForKeys, ForValues, ForPairs =
	Fusion.Value, Fusion.Observer, Fusion.Computed, Fusion.ForKeys, Fusion.ForValues, Fusion.ForPairs
local New, Children, OnEvent, OnChange, Out, Ref, Cleanup =
	Fusion.New, Fusion.Children, Fusion.OnEvent, Fusion.OnChange, Fusion.Out, Fusion.Ref, Fusion.Cleanup
local Tween, Spring = Fusion.Tween, Fusion.Spring

local FlyingKatana = require(script.FlyingKatana)

local function katanaAnimStarted() end

local function newLevel(props)
	local level = New("Frame")({
		Name = "NewLevel",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		[Children] = {
			FlyingKatana(props),
		},
	})

	return level
end

return newLevel
