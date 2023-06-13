local enabled = false

if not enabled then
	return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedPackages = ReplicatedStorage:WaitForChild("Packages")
-- local Players = game:GetService("Players")

-- local player = Players.LocalPlayer

local Red = require(SharedPackages:WaitForChild("Red"))
local Promise = require(SharedPackages:WaitForChild("Promise"))

local SharedModules = ReplicatedStorage:WaitForChild("Modules")

local Interface = require(ReplicatedStorage.Interface)
local FusionMaterial = ReplicatedStorage:WaitForChild("FusionMaterial")
local Tween = require(SharedModules:WaitForChild("Tween"))
local Sound = require(SharedModules:WaitForChild("Sound"))

-- local ClientModules = player:WaitForChild("PlayerScripts"):WaitForChild("Modules")

local Remotes = Red.Client("Events")

local State = require(ReplicatedStorage:WaitForChild("State"))()

local UIComponents = {}
for _, mod in FusionMaterial:GetChildren() do
	UIComponents[mod.Name] = require(mod)
end

local UI = Interface(State, UIComponents)
local CheckpointNotification = UI.CheckpointNotification

local CheckpointReachedPromise
Remotes:On("CheckpointReached", function()
	print("CheckpointReached")
	if CheckpointReachedPromise then
		return
	end

	CheckpointReachedPromise = Promise.all({
		Tween.new( -- flying katana
			CheckpointNotification.Katana,
			TweenInfo.new(4, Enum.EasingStyle.Linear),
			{ Position = UDim2.fromScale(1.3, 0.4) }
		),

		Promise
			.try(State.CheckpointTransparency.set, State.CheckpointTransparency, 0) -- others
			:andThen(function()
				return Promise.delay(6)
			end)
			:andThenCall(State.CheckpointTransparency.set, State.CheckpointTransparency, 1),

		Promise.resolve():andThen(function()
			Sound.new("Checkpoint", CheckpointNotification, {
				TimePosition = 9,
				Volume = 0,
				Name = "CheckpointSound",
			})

			return Promise.all({
				Promise.try(CheckpointNotification.CheckpointSound.Play, CheckpointNotification.CheckpointSound),
				Tween.new(
					CheckpointNotification.CheckpointSound,
					TweenInfo.new(2, Enum.EasingStyle.Linear),
					{ Volume = 1 },
					true
				),
			})
		end),
	})
		:finally(function() -- cleanup
			CheckpointNotification.Katana.Position = UDim2.fromScale(-0.3, 0.4)
			CheckpointNotification.CheckpointSound:Stop()
			State.CheckpointTransparency:set(1)
		end)
		:catch(error)

	CheckpointReachedPromise = nil
end)
