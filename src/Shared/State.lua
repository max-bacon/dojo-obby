local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Signal = require(Packages.Signal)

export type State = {
	CheckpointTransparency: Fusion.Value<number>,
	SkipClickedSignal: Signal.Signal<>,
	ScreenSize: Vector2,
	Stage: Fusion.Value<number>
}

return function(): State
	local checkpointTransparency = Fusion.Value(1)
	local skipClickedSignal = Signal.new()
	local screenSize = workspace.CurrentCamera.ViewportSize
	local stage = Fusion.Value(0)
	
	return {
		CheckpointTransparency = checkpointTransparency,
		SkipClickedSignal = skipClickedSignal,
		ScreenSize = screenSize,
		Stage = stage
	}
end
