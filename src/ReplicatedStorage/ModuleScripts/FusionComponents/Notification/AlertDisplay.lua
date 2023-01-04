local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local Ref = Fusion.Ref

local NOTIFICATION_LIFETIME = 5

local inactiveSize = UDim2.fromScale(0, 0)
local activeSize = UDim2.fromScale(1, 0.238)

local function AlertDisplay(message, priorityFrame)
	local imageRef = Value()
	local sizeChange = Value(inactiveSize)

	task.delay(0.03, function()
		sizeChange:set(activeSize)
	end)

    task.delay(NOTIFICATION_LIFETIME, function()
		if sizeChange then
			sizeChange:set(inactiveSize)
		end
		task.delay(1, function()
			if imageRef and imageRef:get() then
				imageRef:get():Destroy()
				imageRef = nil	
			end
		end)
    end)

	return New "ImageButton" {
		[Ref] = imageRef,
		Parent = priorityFrame,
		Size = Spring(Computed(function()
			return sizeChange:get()
		end), 25, 0.5),

		Active = true,
		Position = UDim2.fromScale(0.5, 0.5),

		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		ZIndex = 55,
		Image = "rbxassetid://10294264542",
				
		[OnEvent "Activated"] = function()
			if sizeChange then
				sizeChange:set(inactiveSize)
			end

			task.delay(1, function()
				if imageRef and imageRef:get() then
					imageRef:get():Destroy()
					imageRef = nil	
				end
			end)
		end,

		[Children] = {
			New "TextLabel" {
				Visible = true,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.8, 0.8),

				Active = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 60,

				RichText = true,
				Text = message,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},
		}
	}
end

return AlertDisplay