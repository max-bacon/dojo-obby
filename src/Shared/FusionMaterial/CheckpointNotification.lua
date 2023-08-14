local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = ReplicatedStorage.Packages
local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Assets.Images).UI
local Sounds = require(ReplicatedStorage.Assets.Sounds)

local rotTime = 2
local degPerSec = 360 / rotTime

return function(checkpointTransparency: Fusion.Value<number>)
	local rotTimer = Fusion.Value(os.clock())

	local spinCon = RunService.RenderStepped:Connect(function()
		rotTimer:set(os.clock())
	end)

	local instance = Fusion.New("Frame")({
		Name = "CheckpointNotification",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		Parent = Player.PlayerGui,
		[Fusion.Children] = {
			-- Katana
			Fusion.New("ImageLabel")({
				Name = "Katana",
				Image = Images.Katana,
				BackgroundTransparency = 1,
				Rotation = Fusion.Computed(function()
					return rotTimer:get() * degPerSec % 360
				end),
				Position = UDim2.fromScale(-0.3, 0.4),
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
				Size = UDim2.fromScale(0.4, 0.191),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageRectSize = Vector2.new(0, 0),
				ImageColor3 = Color3.fromRGB(67, 0, 0),
				ImageTransparency = Fusion.Tween(checkpointTransparency),
				ZIndex = 2,
			}),

			-- Checkpoint Label Shadow
			Fusion.New("ImageLabel")({
				Name = "CheckpointShadow",
				Image = Images.CheckpointText,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.498, 0.205),
				Size = UDim2.fromScale(0.4, 0.191),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageRectSize = Vector2.new(0, 0),
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = Fusion.Tween(checkpointTransparency),
				ZIndex = 1,
			}),

			Fusion.New("Sound")({
				Name = "CheckpointSound",
				Volume = 0,
				SoundId = Sounds.Checkpoint
			})
		},

		[Fusion.Cleanup] = spinCon,
	})

	return instance
end
