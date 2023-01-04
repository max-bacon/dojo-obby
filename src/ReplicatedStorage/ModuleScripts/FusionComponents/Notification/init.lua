local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AlertDisplayHolder = require(script.AlertDisplay)

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Ref = Fusion.Ref

local remotes = ReplicatedStorage.Remotes
local notifyPlayerEvent = remotes.GameServices.ToClient.NotifyPlayer

local bindables = ReplicatedStorage:WaitForChild("Bindables")
local fusionStates = bindables:WaitForChild("FusionStates")

local mainNotifications = Value()
local secondaryNotifications = Value()

local function Notification(prop)
	return New "ScreenGui" {
		Parent = prop,

		Name = "Notification",
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Enabled = true,

		[Children] = {
			--Top notifications
			New "Frame" {
				[Ref] = mainNotifications,
				Visible = true,
				Size = UDim2.fromScale(0.275, 0.5),
				Active = false,

				Position = UDim2.fromScale(0.5, 0.02),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 50,

				--Bottom right notifications
				[Children] = {
					New "UIListLayout" {
						Padding = UDim.new(0.03, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					},
				}
			},

			--Bottom notifications
			New "Frame" {
				[Ref] = secondaryNotifications,
				Visible = true,
				Size = UDim2.fromScale(0.275, 0.5),
				Active = false,

				Position = UDim2.fromScale(0.98, 0.98),
				AnchorPoint = Vector2.new(1, 1),

				BackgroundTransparency = 1,
				ZIndex = 50,

				--Bottom right notifications
				[Children] = {
					New "UIListLayout" {
						Padding = UDim.new(0.03, 0),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
					},
				}
			},
		},
	}
end

local _setNotification = function(message, priority)
	local notificationPriority
	if not priority then
		notificationPriority = secondaryNotifications
	else
		if priority == 1 then
			notificationPriority = mainNotifications
		else
			notificationPriority = secondaryNotifications
		end
	end

	AlertDisplayHolder(message, notificationPriority)
end

fusionStates.SetNotification.Event:Connect(function(message, priority)
	_setNotification(message, priority)
end)

notifyPlayerEvent.OnClientEvent:Connect(function(message, priority)
	_setNotification(message, priority)
end)

return Notification