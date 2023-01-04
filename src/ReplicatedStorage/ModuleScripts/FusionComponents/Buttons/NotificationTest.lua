local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local TIMEOUT = 0.1
local debounce = false

local firstNotificationMessage = "This is a test for the center middle"
local secondNotificationMessage = "This is a test for the bottom right"

local bindables = ReplicatedStorage:WaitForChild("Bindables")
local fusionStates = bindables:WaitForChild("FusionStates")

local function NotificationTest()
	return New "Frame" {
		Position = UDim2.fromScale(0.025, 0.975),
		Size = UDim2.fromScale(0.075, 0.2),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,

		-- INNER FRAME CONTAINER
		[Children] = {
			--Activate Top Middle Notification
			New "TextButton" {
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 0.45),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 0,

				Text = "Priority 1 notification",

				[OnEvent "Activated"] = function()
					if not debounce then
						debounce = true

						fusionStates.SetNotification:Fire(firstNotificationMessage, 1)

						task.wait(TIMEOUT)
						debounce = false
					end
				end,
			},

			--Activate Bottom Right Notification
			New "TextButton" {
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.45),
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 0,
				
				Text = "Priority 2 notification",

				[OnEvent "Activated"] = function()
					if not debounce then
						debounce = true

						fusionStates.SetNotification:Fire(secondNotificationMessage, 2)

						task.wait(TIMEOUT)
						debounce = false
					end
				end,
			},
		}
	}
end

return NotificationTest