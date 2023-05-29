local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(Player.PlayerScripts.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Modules.Images).UI

local instance
local labelTransparency

local Time = 5
local delayTime = 0.8

local module = {}

function module.Construct(state: State)
	labelTransparency = state.CheckpointTransparency
	print("run")
	instance = Fusion.New("ScreenGui")({
		Name = "CheckpointNotification",
		Parent = Player.PlayerGui,
		[Fusion.Children] = {
			-- Katana
			Fusion.New("ImageLabel")({
				Name = "Katana",
				Image = Images.Katana,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.3, 0.5),
				Size = UDim2.fromScale(0.308, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),

				[Fusion.Children] = {
					Fusion.New("UIAspectRatioConstraint")({
						AspectRatio = 7.452041306803273,
					}),
				},
			}),

			-- Checkpoint Label
			Fusion.New("ImageLabel")({
				Name = "CheckpointLabel",
				Image = Images.CheckpointText,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.502, 0.2),
				Size = UDim2.fromScale(0, 0.191),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageRectSize = Vector2.new(0, 5),
				ImageColor3 = Color3.fromRGB(67, 0, 0),
				ImageTransparency = Fusion.Tween(labelTransparency),
				ZIndex = 2,
			}),

			-- Checkpoint Label Shadow
			Fusion.New("ImageLabel")({
				Name = "CheckpointShadow",
				Image = Images.CheckpointText,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.498, 0.205),
				Size = UDim2.fromScale(0, 0.191),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageRectSize = Vector2.new(0, 5),
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = Fusion.Tween(labelTransparency),
				ZIndex = 1,
			}),
		},
	})

	return instance
end

return module
