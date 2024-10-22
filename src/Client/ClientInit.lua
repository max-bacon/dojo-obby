--@localscript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local SharedPackages = ReplicatedStorage:WaitForChild("Packages")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Red = require(SharedPackages:WaitForChild("Red"))
local Promise = require(SharedPackages:WaitForChild("Promise"))

local SharedModules = ReplicatedStorage:WaitForChild("Modules")

local Interface = require(ReplicatedStorage.Interface)
local FusionMaterial = ReplicatedStorage:WaitForChild("FusionMaterial")
local Tween = require(SharedModules:WaitForChild("Tween"))

local Robux = require(ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Robux"))

local leaderstats = player:WaitForChild("leaderstats")
local StageValue: NumberValue = leaderstats:WaitForChild("Stage")
local WinsValue: NumberValue = leaderstats:WaitForChild("Wins")
assert(StageValue:IsA("IntValue") and WinsValue:IsA("IntValue"))

-- local ClientModules = player:WaitForChild("PlayerScripts"):WaitForChild("Modules")

local Network = Red.Client("Network")

local State = require(ReplicatedStorage:WaitForChild("State"))()

local Components = {}
for _, c in player:WaitForChild("PlayerScripts"):WaitForChild("Components"):GetChildren() do
	Components[c.Name] = require(c) :: any
end

local UIComponents = {}
require(FusionMaterial.CheckpointNotification)
for _, mod: ModuleScript in FusionMaterial:GetChildren() do
	UIComponents[mod.Name] = require(mod) :: any
end

local UI = Interface(State, UIComponents)

State.SkipClickedSignal:Connect(function()
	MarketplaceService:PromptProductPurchase(player, Robux.Product.SkipStage)
end)

task.spawn(function()
	local CheckpointNotification = UI:FindFirstChild("CheckpointNotification")
	assert(CheckpointNotification)

	local Katana = CheckpointNotification:FindFirstChild("Katana")
	assert(Katana and Katana:IsA("ImageLabel"))

	local CheckpointSound = CheckpointNotification:FindFirstChild("CheckpointSound")
	assert(CheckpointSound and CheckpointSound:IsA("Sound"))

	local CheckpointReachedPromise: any

	StageValue.Changed:Connect(function(value)
		State.Stage:set(value)

		if CheckpointReachedPromise then
			CheckpointReachedPromise:cancel()
		end

		print("CheckpointReached")

		CheckpointReachedPromise = Promise.all({
			Tween.new( -- flying katana
				Katana,
				TweenInfo.new(4, Enum.EasingStyle.Linear),
				{ Position = UDim2.fromScale(1.3, 0.4) }
			),

			Promise
				.resolve() -- others
				:andThenCall(State.CheckpointTransparency.set, State.CheckpointTransparency, 0)
				:andThen(function()
					return Promise.delay(6)
				end)
				:andThenCall(State.CheckpointTransparency.set, State.CheckpointTransparency, 1),

			Promise.resolve():andThen(function()
				CheckpointSound.TimePosition = 9
				CheckpointSound.Volume = 0

				print("playing sound")
				CheckpointSound:Play()
				print(CheckpointSound.Playing)
				return Tween.new(CheckpointSound, TweenInfo.new(2, Enum.EasingStyle.Linear), { Volume = 1 }, true)
			end),
		})
			:finally(function() -- cleanup
				print("done")
				Katana.Position = UDim2.fromScale(-0.3, 0.4)
				CheckpointSound:Stop()
				CheckpointSound.Volume = 0
				State.CheckpointTransparency:set(1)
				CheckpointReachedPromise = nil
			end)
			:catch(error)
	end)
end)
