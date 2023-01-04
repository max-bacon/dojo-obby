local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local assetsFolder = ReplicatedStorage.Assets

local bindables = ReplicatedStorage:WaitForChild("Bindables")
local fusionStates = bindables:WaitForChild("FusionStates")
local settingsRemotes = ReplicatedStorage.Remotes.PlayerSettings
local updateSetting = bindables:WaitForChild("GameServices"):WaitForChild("Client"):WaitForChild("UpdateSetting")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Ref = Fusion.Ref
local Value = Fusion.Value
local Hydrate = Fusion.Hydrate
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring
local ComputedPairs = Fusion.ComputedPairs

local hoveringXButton = Value(nil)

local activeColor = Color3.fromRGB(255, 191, 71)
local inactiveColor = Color3.fromRGB(255, 255, 255)
local hoveringColor = Color3.fromRGB(255, 236, 201)

local activeToggleColor = Color3.fromRGB(90, 93, 94)
local inactiveToggleColor = Color3.fromRGB(29, 33, 34)

local activeTogglePosition = UDim2.fromScale(1, 0.5)
local inactiveTogglePosition = UDim2.fromScale(0, 0.5)

local settingsData = {
	[1] = {
		promptType = "title",
		name = "Audio",
	},

	[2] = {
		promptType = "settingToggle",
		name = "Music",
		settingState = Value(false),
	},

	[3] = {
		promptType = "settingToggle",
		name = "Sound Effects",
		settingState = Value(false),
	},

	[4] = {
		promptType = "title",
		name = "Visuals",
	},

	[5] = {
		promptType = "settingToggle",
		name = "Shadows",
		settingState = Value(false),
	},
}

local function categoryTitleFrame(layoutOrder, prop)
	return New "Frame" {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.78, 0.111),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 12,
		LayoutOrder = layoutOrder,

		[Children] = {
			--Title
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 0.9),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				Text = prop.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--Dash
			New "ImageLabel" {
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.1),		
				
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				ZIndex = 14,
				Image = "rbxassetid://10100632491",
				ScaleType = Enum.ScaleType.Fit,
			},
		}
	}
end

local function settingToggleFrame(layoutOrder, prop)
	-- local settingButtonState = Value(nil)
	local buttonDebounce = false

	return New "Frame" {
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.78, 0.111),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 12,
		LayoutOrder = layoutOrder,

		[Children] = {
			--Setting type
			New "TextLabel" {
				Visible = true,
				Position = UDim2.fromScale(0.05, 0.5),
				Size = UDim2.fromScale(0.6, 1),

				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 15,

				Text = prop.name,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--Background
			New "ImageLabel" {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),		
				
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 14,
				Image = "rbxassetid://10100632719",
				ScaleType = Enum.ScaleType.Fit,
			},

			--Toggle button
			New "ImageButton" {
				Visible = true,
				Position = UDim2.fromScale(0.825+0.0875, 0.5),
				Size = UDim2.fromScale(0.174, 0.385),

				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 14,
				Image = "rbxassetid://10100632010",
				ScaleType = Enum.ScaleType.Fit,
				Active = true,

				ImageColor3 = Spring(Computed(function()
					return prop.settingState:get() and activeToggleColor or inactiveToggleColor
				end), 20),
		
				[OnEvent "Activated"] = function()
					if not buttonDebounce then
						buttonDebounce = true
						prop.settingState:set(not prop.settingState:get())
						updateSetting:Fire(prop.name, prop.settingState:get())
						settingsRemotes.ToServer.SetSetting:FireServer(prop.name, prop.settingState:get())

						task.wait(0.3)
						buttonDebounce = false
					end
				end,

				[Children] = {
					--Toggle circle
					New "ImageLabel" {
						Visible = true,
						Size = UDim2.fromScale(0.357, 1),
						BackgroundTransparency = 1,
						ZIndex = 15,
						Image = "rbxassetid://10100631643",
						ScaleType = Enum.ScaleType.Fit,
						Active = true,

						Position = Spring(Computed(function()
							return prop.settingState:get() and activeTogglePosition or inactiveTogglePosition
						end), 20),

						AnchorPoint = Spring(Computed(function()
							return prop.settingState:get() and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
						end), 20),
					},
				}
			},
		}
	}
end

local function Settings(selectedCategoryState)
	return New "Frame" {
		Name = "Settings",
		Position = UDim2.fromScale(0.5, 0.475),
		Size = UDim2.fromScale(0.283, 0.753),

		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,

		Visible = Computed(function()
			return selectedCategoryState:get() == "settings" and true or false
		end),

		[Children] = {
			New "UIAspectRatioConstraint" {
				AspectRatio = 0.777,
			},

			--Background Image
			New "ImageLabel" {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),		
				
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Image = "rbxassetid://10100632266",
				ScaleType = Enum.ScaleType.Fit,

			},

			--X button
			New "ImageButton" {
				Visible = true,
				Position = UDim2.fromScale(0.97, 0.02),
				Size = UDim2.fromScale(0.0987, 0.0816),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 10,
				Image = "rbxassetid://10064351587",
				ScaleType = Enum.ScaleType.Fit,

				-- hoveringXButton
				ImageColor3 = Spring(Computed(function()
					return hoveringXButton:get() and hoveringColor or inactiveColor
				end), 20),
		
				[OnEvent "Activated"] = function()
					selectedCategoryState:set(nil)
				end,
		
				[OnEvent "MouseEnter"] = function()
					hoveringXButton:set(true)
				end,
			
				[OnEvent "MouseLeave"] = function()
					hoveringXButton:set(false)
				end,
			},

			--Settings title
			New "TextLabel" {
				Visible = true,
				Position = UDim2.fromScale(0.5, 0.05),
				Size = UDim2.fromScale(0.28, 0.1),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 10,

				Text = "Settings",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},
			
			--Frame to hold the different kinds of settings
			New "Frame" {
				Visible = true,
				Position = UDim2.fromScale(0.5, 0.525),
				Size = UDim2.fromScale(0.9, 0.8),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 11,

				[Children] = {
					New "UIListLayout" {
						Padding = UDim.new(0.05, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					},

					ComputedPairs(settingsData, function(key, index)
						if index.promptType == "title" then
							return categoryTitleFrame(key, index)
						else
							return settingToggleFrame(key, index)
						end
					end)
				}
			},
		},
	}
end

fusionStates.SettingUpdated.Event:Connect(function(itemKey, value)
	for _, index in pairs(settingsData) do
		if index.name == itemKey then
			index.settingState:set(value)
		end
	end
end)

return Settings
