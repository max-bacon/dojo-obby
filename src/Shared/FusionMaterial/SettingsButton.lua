local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Assets.Images).UI

return function()
	local instance = Fusion.New("ImageButton")({
		Name = "SettingsButton",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(.1, .1),
        AnchorPoint = Vector2.new(.5, .5),
		Image = Images.SettingsButton,

		[Fusion.Children] = {Fusion.New("UIAspectRatioConstraint")({
			AspectRatio = 1
		})},
	})

	return instance
end
