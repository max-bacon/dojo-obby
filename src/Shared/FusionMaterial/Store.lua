local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages

local State = require(ReplicatedStorage.State)
type State = State.State

local Fusion = require(Packages.Fusion)

local Images = require(ReplicatedStorage.Assets.Images).UI

return function(checkpointTransparency: Fusion.Value<number>)


    
	local instance = Fusion.New("Frame")({
		Name = "Store",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),

		Parent = Player.PlayerGui,
		[Fusion.Children] = {
			
		},
	})

	return instance
end
