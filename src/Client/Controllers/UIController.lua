local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(game:GetService("ReplicatedStorage").Utils.Knit)

local Fusion = require(ReplicatedStorage.Utils.Fusion)

local UIComponentsFolder = script.Parent.Parent.Modules.UIComponents

local UIController = Knit.CreateController({ Name = "UIController", UIComponents = {} })

local New, Children = Fusion.New, Fusion.Children

function UIController:Get(name: string)
	return self.UIComponents[name]
end

function UIController:KnitStart()
	local StatsService = Knit.GetService("StatsService")
	self.Gui = New("ScreenGui")({
		Name = "Main",
		Parent = game.Players.LocalPlayer.PlayerGui,

		[Children] = {
			self:Get("NewLevel")({
				Event = StatsService.CheckpointReached,
			}),
		},
	})
end

function UIController:KnitInit()
	self.GUI = Instance.new("ScreenGui")
	self.GUI.Name = "MainGUI"

	for _, mod in pairs(UIComponentsFolder:GetChildren()) do
		self.UIComponents[mod.Name] = require(mod)
	end
end

return UIController
