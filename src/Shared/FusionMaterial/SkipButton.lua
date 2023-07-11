local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)
local Signal = require(Packages.Signal)

local Images = require(ReplicatedStorage.Assets.Images).UI

local function calculateSliceScale(screenHeight: number)
	local constant = 2700 -- screenSize/x = desiredScale (x == constant)

	return screenHeight / constant
end

return function(skipClickedSignal: Signal.Signal<...any>, screenSize: Vector2, stage: Fusion.Value<number>, skipButtonVisible: Fusion.Value<boolean>)
	local imageColor = Fusion.Value(Color3.fromRGB(0, 255, 0))

	local instance = Fusion.New("ImageButton")({
		Name = "SkipButton",
		Size = UDim2.fromScale(0.1, 0.1),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		ImageColor3 = Fusion.Tween(imageColor),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(18, 18, 1004, 320),
		SliceScale = calculateSliceScale(screenSize.Y),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Image = Images.ButtonBackground,
		Visible = Fusion.Computed(function()
			return stage:get() < #workspace.Checkpoints:GetChildren() - 1 and skipButtonVisible:get()
		end),

		[Fusion.OnEvent("MouseButton1Click")] = function()
			skipClickedSignal:Fire()
		end,

		[Fusion.OnEvent("MouseEnter")] = function()
			imageColor:set(Color3.fromRGB(0, 51, 0))
		end,

		[Fusion.OnEvent("MouseLeave")] = function()
			imageColor:set(Color3.fromRGB(0, 255, 0))
		end,

		[Fusion.Children] = {
			Fusion.New("ImageLabel")({
				Name = "Text",
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.8, 0.8),
				Image = Images.SkipText,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,

				[Fusion.Children] = {
					Fusion.New("UIAspectRatioConstraint")({
						AspectRatio = 2,
					}),
				},
			}),

			Fusion.New("UICorner")({}),
		},
	})

	return instance
end
