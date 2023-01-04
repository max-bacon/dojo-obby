local StateLogic = {}

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--Modules
local remotes = ReplicatedStorage.Remotes

--Events
local playerLoadedIntoGameRemoteEvent = remotes.GameServices.ToClient.PlayerLoaded

--Handle player state when new player added to game
StateLogic.playerAdded = function(player)
	playerLoadedIntoGameRemoteEvent:FireClient(player)
	player:LoadCharacter()

end

StateLogic.playerRemoving = function(_)
	--@TODO

end

StateLogic.init = function()
    Players.PlayerAdded:Connect(StateLogic.playerAdded)
    Players.PlayerRemoving:Connect(StateLogic.playerRemoving)
end

return StateLogic