local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local InterfaceWrapper = require(script.InterfaceWrapper)
local TopButtons = require(script.TopButtons)
local SettingsHolder = require(script.Settings)
local CodesHolder = require(script.Codes)
local NotificationTest = require(script.Parent.Buttons.NotificationTest)

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Ref = Fusion.Ref
local Observer = Fusion.Observer
local Computed = Fusion.Computed

local remotes = ReplicatedStorage.Remotes
local playerDiedRemoteEvent = remotes.PlayerState.ToClient.PlayerDied

local currentScreenGui = Value()
local selectedCategoryState = Value(false)

local bindables = ReplicatedStorage:WaitForChild("Bindables")
local toggleStartScreenBindableEvent = bindables:WaitForChild("GameServices"):WaitForChild("Client"):WaitForChild("ToggleStartScreen")
local fusionStates = bindables:WaitForChild("FusionStates")
local uiBlur = Lighting:WaitForChild("Blur")

local shouldDisplay = Value()

if RunService:IsRunning() then
	shouldDisplay:set(false)
else
	shouldDisplay:set(true)
end

local leftSideButtons = {
	codes = {1, "rbxassetid://10063794101"},
}

local rightSideButtons = {
	settings = {1, "rbxassetid://10063794576"},
}

local function MainInterface(prop)
	Observer(selectedCategoryState):onChange(function()
		if not selectedCategoryState:get() then
			uiBlur.Size = 0
		else
			uiBlur.Size = 12
		end
	end)

    local topRightComponents = {
		TopButtons(rightSideButtons, selectedCategoryState),
	}

	local topLeftComponents = {
		TopButtons(leftSideButtons, selectedCategoryState),
	}

    local bottomRightComponents = {
	}

	local bottomLeftComponents = {
	}

    --Components positioned relative to the whole screen
    local wholeScreenComponents = Value({
		SettingsHolder(selectedCategoryState),
		CodesHolder(selectedCategoryState),
		NotificationTest(),
	})

	return New "ScreenGui" {
		Parent = prop,

		Name = "MainInterface",
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,

		Enabled = Computed(function()
			return shouldDisplay:get()
		end),

		[Ref] = currentScreenGui,

		[Children] = {
			InterfaceWrapper { 
				topRightComponents = topRightComponents,
				topLeftComponents = topLeftComponents,
				bottomRightComponents = bottomRightComponents,
				bottomLeftComponents = bottomLeftComponents,
				wholeScreenComponents = wholeScreenComponents,
			},
		},
	}
end

playerDiedRemoteEvent.OnClientEvent:Connect(function()
	selectedCategoryState:set(false)
	shouldDisplay:set(true)
end)

toggleStartScreenBindableEvent.Event:Connect(function()
	selectedCategoryState:set(false)
	shouldDisplay:set(true)
end)

fusionStates.PlayerSpawned.Event:Connect(function()
	selectedCategoryState:set(false)
	shouldDisplay:set(true)
end)

return MainInterface