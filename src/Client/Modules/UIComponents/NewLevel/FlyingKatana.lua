local timeDuration = 5

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Utils.Fusion)
local BezierTween = require(ReplicatedStorage.Utils.BezierTween)
local TweenService = game:GetService("TweenService")
local Waypoints = BezierTween.Waypoints
local Images = require(ReplicatedStorage.Shared.Modules.Images)
local Trove = require(ReplicatedStorage.Utils.Trove)

local Value, Observer, Computed, ForKeys, ForValues, ForPairs =
	Fusion.Value, Fusion.Observer, Fusion.Computed, Fusion.ForKeys, Fusion.ForValues, Fusion.ForPairs
local New, Children, OnEvent, OnChange, Out, Ref, Cleanup =
	Fusion.New, Fusion.Children, Fusion.OnEvent, Fusion.OnChange, Fusion.Out, Fusion.Ref, Fusion.Cleanup
local Tween, Spring = Fusion.Tween, Fusion.Spring

local KatanaImage = Images.UI.Katana

local path = Waypoints.new(UDim2.fromScale(-0.3, 0.7), UDim2.fromScale(0.5, -0.1), UDim2.fromScale(1.3, 0.7))

local function flyingAnimInit(katanaIns)
	print("go")
	print(katanaIns)
	print(BezierTween.Create)
	print(path)
	local SpinTween = TweenService:Create(
		katanaIns,
		TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
		{ Rotation = 360 }
	)

	local BezTween = BezierTween.Create(katanaIns, {
		Waypoints = path,
		EasingStyle = Enum.EasingStyle.Sine,
		EasingDirection = Enum.EasingDirection.InOut,
		Time = timeDuration,
	})
	SpinTween:Play()
	BezTween:Play()

	BezTween.Completed:Wait()
	SpinTween:Cancel()

	katanaIns.Position = UDim2.fromScale(-0.3, 0.7)
end

local function katana(props)
	local trove = Trove.new()

	local katanaIns = New("ImageLabel")({
		Name = "Katana",
		Image = KatanaImage,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(-0.3, 0.7),
		Size = UDim2.fromScale(0.308, 1),
		AnchorPoint = Vector2.new(0.3, 0.5),
		[Out("Position")] = props.Position,

		[Cleanup] = function()
			trove:Clean()
		end,

		[Children] = {
			New("UIAspectRatioConstraint")({
				AspectRatio = 1057 / 81,
			}),
		},
	})

	trove:Add(props.Event:Connect(function()
		flyingAnimInit(katanaIns)
	end))

	return katanaIns
end

return katana
