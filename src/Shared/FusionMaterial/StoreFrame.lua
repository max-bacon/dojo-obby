local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Assets.Images).UI

return function()
	local instance = Fusion.New("Frame")({
		Name = "StoreFrame",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		[Fusion.Children] = {},
	})

	return instance
end
