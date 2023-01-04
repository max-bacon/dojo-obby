local UserInterfaceLoader = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts")
local bindables = ReplicatedStorage:WaitForChild("Bindables")

local toggleStartScreenBindableEvent = bindables:WaitForChild("GameServices"):WaitForChild("Client"):WaitForChild("ToggleStartScreen")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local playerLoadedIntoGameRemoteEvent = remotes.GameServices.ToClient.PlayerLoaded

UserInterfaceLoader.loadOnJoiningGame = function()
	local MainInterface = require(moduleScripts.FusionComponents.MainInterface)
	local Notification = require(moduleScripts.FusionComponents.Notification)

	local player = Players.LocalPlayer
	local playerGui = player.PlayerGui

	MainInterface(playerGui)
	Notification(playerGui)

	toggleStartScreenBindableEvent:Fire()

end

UserInterfaceLoader.init = function()
	playerLoadedIntoGameRemoteEvent.OnClientEvent:Connect(UserInterfaceLoader.loadOnJoiningGame)
end

return UserInterfaceLoader