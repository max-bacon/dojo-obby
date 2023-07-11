local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local State = require(ReplicatedStorage.State)

local FusionMaterial = ReplicatedStorage.FusionMaterial

type State = State.State

return function(state: State, components: { [string]: (...any) -> () })
	local buttonVisibility = {state.SettingsButtonVisible, state.StoreButtonVisible, state.SkipButtonVisible}

	return Fusion.New("ScreenGui")({
		Parent = Player:WaitForChild("PlayerGui"),
		Name = "Main",
		[Fusion.Children] = {
			components.CheckpointNotification(state.CheckpointTransparency),
			components.SkipButton(state.SkipClickedSignal, state.ScreenSize, state.Stage, state.SkipButtonVisible),
			components.SettingsFrame(),
			components.SettingsButton(),
			components.StoreFrame(state.StoreFrameVisible, buttonVisibility),
			components.StoreButton(state.StoreButtonVisible, state.StoreFrameVisible, buttonVisibility, state.ScreenSize),
		},
	})
end
