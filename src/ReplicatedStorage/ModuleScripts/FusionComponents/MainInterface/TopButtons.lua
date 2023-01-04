local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Computed = Fusion.Computed

local ComputedPairs = Fusion.ComputedPairs
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring

local activeColor = Color3.fromRGB(255, 191, 71)
local inactiveColor = Color3.fromRGB(255, 255, 255)
local hoveringColor = Color3.fromRGB(255, 236, 201)

--Creates the buttons for the ui
local createHudTopBarButton = function(key, props, selectedCategoryState)
	local buttonState = Value(inactiveColor)

	return New "ImageButton" {
		Visible = true,
		Name = key,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.074, 0.181),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 7,
		LayoutOrder = props[1],
		Image = "rbxassetid://10063792712",

		ImageColor3 = Spring(Computed(function()
			return selectedCategoryState:get() == key and activeColor or buttonState:get()
		end), 20),

		[OnEvent "Activated"] = function(input)
			if selectedCategoryState:get() ~= key then
				selectedCategoryState:set(key)
			else
				selectedCategoryState:set(false)
			end
			buttonState:set(selectedCategoryState:get() == key and activeColor or inactiveColor)
		end,
		
		[OnEvent "MouseEnter"] = function()
			buttonState:set(hoveringColor)
		end,
	
		[OnEvent "MouseLeave"] = function()
			buttonState:set(inactiveColor)
		end,

		[Children] = {
			New "ImageLabel" {
				Visible = true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Image = props[2],

				ImageColor3 = Spring(Computed(function()
					return selectedCategoryState:get() == key and hoveringColor or buttonState:get()
				end), 20),
			}
		}
	}
end

local function TopButtons(props, selectedCategoryState)
	return New "Frame" {
		Name = "ButtonsFrame",
		Position = UDim2.fromScale(0.5, 0.02),
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ZIndex = 5,

		[Children] = {
			New "UIAspectRatioConstraint" {
				AspectRatio = 2.426,
			},

			New "UIListLayout" {
				Padding = UDim.new(0.02, 0),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			},

			ComputedPairs(props, function(key, value)
				return
				createHudTopBarButton(
					key,
					value,
					selectedCategoryState
				)
			end),
		},
	}
end

return TopButtons