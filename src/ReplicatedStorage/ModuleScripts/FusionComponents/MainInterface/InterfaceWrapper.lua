local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)

local New = Fusion.New
local Children = Fusion.Children

local function InterfaceWrapper(props)
    local topRightComponents = props.topRightComponents
	local topLeftComponents = props.topLeftComponents
    local bottomRightComponents = props.bottomRightComponents
    local bottomLeftComponents = props.bottomLeftComponents
    local wholeScreenComponents = props.wholeScreenComponents

	return {
		[Children] = {
			TopRightFrame = New "Frame" {
				Name = "TopRightFrame",
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(0.5, 0, 0),

				Size = UDim2.fromScale(0.5, 0.5),
				Position = UDim2.fromScale(1, 0),
				AnchorPoint = Vector2.new(1, 0),

				[Children] = topRightComponents,
			},

			TopLeftFrame = New "Frame" {
				Name = "TopLeftFrame",
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(0, 1, 0),
				
				Size = UDim2.fromScale(0.5, 0.5),
				Position = UDim2.fromScale(0, 0),
				AnchorPoint = Vector2.new(0, 0),

				[Children] = topLeftComponents,
			},
			
			BottomRightFrame = New "Frame" {
				Name = "BottomRightFrame",
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(1, 1, 0),
				
				Size = UDim2.fromScale(0.5, 0.5),
				Position = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(1, 1),

				[Children] = bottomRightComponents,
			},
			
			BottomLeftFrame = New "Frame" {
				Name = "BottomLeftFrame",
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(0, 0, 1),
				
				Size = UDim2.fromScale(0.5, 0.5),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),

				[Children] = bottomLeftComponents, 
			}, 

			wholeScreenComponents = New "Frame" {
				Name = "wholeScreenComponents",
				BackgroundTransparency = 1,
				-- BackgroundColor3 = Color3.new(0, 0, 0),
				
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),

				[Children] = wholeScreenComponents,
			}
		}
	}
end

return InterfaceWrapper