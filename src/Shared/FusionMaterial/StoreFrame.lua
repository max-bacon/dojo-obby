local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Assets.Images).UI

return function(storeFrameVisible: Fusion.Value<boolean>, buttonVisibility: { Fusion.Value<boolean> })
	local instance = Fusion.New("Frame")({
		Name = "StoreFrame",
		BackgroundTransparency = 0.5,
		Size = UDim2.fromScale(0.8, 0.8),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Visible = storeFrameVisible,

		[Fusion.Children] = {
			Fusion.New("UIAspectRatioConstraint")({
				AspectRatio = 2,
			}),
			Fusion.New("ImageButton")({
				BackgroundTransparency = 0.5,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				Visible = true,
				Size = UDim2.fromScale(0.2, 0.1	),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(.975, 0.05),

				[Fusion.OnEvent("MouseButton1Click")] = function()
					for _, v in buttonVisibility do
						print(v)
						v:set(not v:get())
					end
					storeFrameVisible:set(not storeFrameVisible:get())
				end,

				[Fusion.Children] = {
					Fusion.New("UIAspectRatioConstraint")({
						AspectRatio = 1,
					}),
					Fusion.New("UICorner")({}),
				},
			}),
		},
	})

	return instance
end
