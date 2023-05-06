local StartPosition = UDim2.fromScale(-0.3, 0.7)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Utils.Fusion)
local BezierTween = require(ReplicatedStorage.Utils.BezierTween)
local TweenService = game:GetService("TweenService")
local Waypoints = BezierTween.Waypoints
local Images = require(ReplicatedStorage.Shared.Modules.Images)
local Trove = require(ReplicatedStorage.Utils.Trove)
local Promise = require(ReplicatedStorage.Utils.Promise)

local New, Children, Out, Cleanup = Fusion.New, Fusion.Children, Fusion.Out, Fusion.Cleanup

local KatanaImage = Images.UI.Katana

local path = Waypoints.new(UDim2.fromScale(-0.3, 0.7), UDim2.fromScale(0.5, -0.1), UDim2.fromScale(1.3, 0.7))

local function flyingAnimInit(katanaIns, time)
	return Promise.new(function(resolve, _, onCancel)
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
			Time = time,
		})

		if onCancel(function()
			BezTween:Cancel()
			SpinTween:Cancel()
			katanaIns.Rotation = 0
		end) then
			return
		end
		SpinTween:Play()
		BezTween:Play()

		BezTween.Completed:Wait()
		SpinTween:Cancel()
		BezTween:Cancel()
		katanaIns.Rotation = 0

		--katanaIns.Position = StartPosition
		resolve()
	end)
end

local function katana(props)
	local trove = Trove.new()

	local katanaIns = New("ImageLabel")({
		Name = "Katana",
		Image = KatanaImage,
		BackgroundTransparency = 1,
		Position = StartPosition,
		Size = UDim2.fromScale(0.308, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		[Out("AbsolutePosition")] = props.Position,

		[Cleanup] = function()
			trove:Clean()
		end,

		[Children] = {
			New("UIAspectRatioConstraint")({
				AspectRatio = 7.452041306803273,
			}),
		},
	})
	local lastAnim
	trove:Add(props.Event:Connect(function()
		if lastAnim then
			print("cacnel")
			lastAnim:cancel()
		end
		lastAnim = flyingAnimInit(katanaIns, props.Time):andThen(function()
			lastAnim = nil
		end)
	end))

	return katanaIns
end

return katana
