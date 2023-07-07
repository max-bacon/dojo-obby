local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local State = require(ReplicatedStorage.State)

local FusionMaterial = ReplicatedStorage.FusionMaterial

type State = State.State

return function(state: State, components: { [string]: (...any) -> () })
	return Fusion.New("ScreenGui")({
		Parent = Player:WaitForChild("PlayerGui"),
		Name = "Main",
		[Fusion.Children] = {
			components.CheckpointNotification(state.CheckpointTransparency),
			components.SkipButton(state.SkipClickedSignal, state.ScreenSize, state.Stage),
			components.SettingsFrame(),
			components.SettingsButton(),
			components.StoreFrame(),
			components.StoreButton(state.StoreButtonVisible, {state.StoreFrameVisible, state.StoreButtonVisible, state.SkipButtonVisible}, state.ScreenSize),
		},
	})
end
