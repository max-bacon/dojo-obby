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

return function(storeButtonVisible: Fusion.Value<boolean>, storeFrameVisible: Fusion.Value<boolean>, buttonVisibility: {Fusion.Value<boolean>}, screenSize: Vector2)
	local startColor = Color3.fromRGB(0, 255, 0)
	local endColor = Color3.fromRGB(0, 51, 0)
	local imageColor = Fusion.Value(startColor)

	local instance = Fusion.New("ImageButton")({
		Name = "StoreButton",
		Size = UDim2.fromScale(0.1, 0.1),
		AnchorPoint = Vector2.new(1, .5),
		Position = UDim2.fromScale(1, .5),
		ImageColor3 = Fusion.Tween(imageColor),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(18, 18, 1004, 320),
		SliceScale = calculateSliceScale(screenSize.Y),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Image = Images.ButtonBackground,
		Visible = storeButtonVisible,

		[Fusion.OnEvent("MouseButton1Click")] = function()
			for _, v in buttonVisibility do
				v:set(not v:get())
			end
			storeFrameVisible:set(not storeFrameVisible:get())
		end,

		[Fusion.OnEvent("MouseEnter")] = function()
			imageColor:set(endColor)
		end,

		[Fusion.OnEvent("MouseLeave")] = function()
			imageColor:set(startColor)
		end,

		[Fusion.Children] = {
			Fusion.New("ImageLabel")({
				Name = "Text",
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.8, 0.8),
				Image = Images.StoreButton,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,

				[Fusion.Children] = {
					Fusion.New("UIAspectRatioConstraint")({
						AspectRatio = 1,
					}),
				},
			}),

			Fusion.New("UICorner")({}),

			Fusion.New("UIAspectRatioConstraint")({
				AspectRatio = 1,
			}),
		},
	})

	return instance
end
