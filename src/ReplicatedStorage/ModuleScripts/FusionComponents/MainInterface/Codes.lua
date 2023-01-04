local PolicyService = game:GetService("PolicyService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes")
local validCodeCheck = remotesFolder:WaitForChild("GameServices"):WaitForChild("ToServer"):WaitForChild("ValidCodeCheck")

local Fusion = require(ReplicatedStorage.Vendor.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Ref = Fusion.Ref
local Value = Fusion.Value
local Computed = Fusion.Computed
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring

local hoveringXButton = Value(nil)
local hoveringSubmitButton = Value(nil)

local inactiveColor = Color3.fromRGB(255, 255, 255)
local hoveringColor = Color3.fromRGB(255, 236, 201)

local validColor = Color3.new(0.1, 1, 0.1)
local invalidColor = Color3.fromRGB(223, 98, 98)
local neutralColor = Color3.fromRGB(255, 255, 255)

local inputCodeDebounce = false

local textState = Value(neutralColor)
local nameTextBox = Value()

local playerAllowed = function()
	return New "Frame" {
		Position = UDim2.fromScale(0.5, 0.12),
		Size = UDim2.fromScale(0.8, 0.44),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ZIndex = 11,

		[Children] = {
			--Title
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.fromScale(1, 0.2),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				RichText = true,
				Text = "<b>Follow our social to find codes!</b>",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--twitter plug
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(1, 0.15),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				RichText = true,
				Text = "Twitter - @TVLDev",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--tiktok plug
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0.4),
				Size = UDim2.fromScale(1, 0.15),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				RichText = true,
				Text = "TikTok - @tvlofficial",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--youtube plug
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0.6),
				Size = UDim2.fromScale(1, 0.15),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				RichText = true,
				Text = "Youtube @thevampirelegacies",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--discord plug
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(1, 0.15),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				RichText = true,
				Text = "https://discord.gg/tvl",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},
		}
	}
end

local playerNotAllowed = function()
	return New "Frame" {
		Position = UDim2.fromScale(0.5, 0.12),
		Size = UDim2.fromScale(0.8, 0.44),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		ZIndex = 11,

		[Children] = {
			--Title
			New "TextLabel" {
				Position = UDim2.fromScale(0.5, 0.25),
				Size = UDim2.fromScale(1, 0.5),

				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				ZIndex = 15,

				Text = "Find codes to unlock special in-game rewards!",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},
		}
	}
end

local checkPlayer = function()
	if not RunService:IsRunning() then
		return playerNotAllowed()
	end

	local result, policyInfo = pcall(function()
		return PolicyService:GetPolicyInfoForPlayerAsync(Players.LocalPlayer)
	end)

	if not result then
		playerNotAllowed()
	elseif not policyInfo.AllowedExternalLinkReferences then
		return playerNotAllowed()
	else
		return playerAllowed()
	end
end

local function Codes(selectedCategoryState)
	return New "Frame" {
		Name = "Codes",
		Position = UDim2.fromScale(0.5, 0.475),
		Size = UDim2.fromScale(0.404, 0.753),

		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,

		Visible = Computed(function()
			return selectedCategoryState:get() == "codes" and true or false
		end),

		[Children] = {
			New "UIAspectRatioConstraint" {
				AspectRatio = 1.132,
			},
			
			--Codes title
			New "TextLabel" {
				Visible = true,
				Position = UDim2.fromScale(0.5, 0.055),
				Size = UDim2.fromScale(0.28, 0.08),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 10,

				Text = "Codes",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = Enum.Font.Bodoni,
			},

			--X button
			New "ImageButton" {
				Visible = true,
				Position = UDim2.fromScale(0.97, 0.02),
				Size = UDim2.fromScale(0.08, 0.0816),

				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 9,
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

			--Background Image
			New "ImageLabel" {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),		
				
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Image = "rbxassetid://10106043521",
				ScaleType = Enum.ScaleType.Fit,
			},

			--Confirm button
			New "ImageButton" {
				Name = "ContinueButton",
				Position = UDim2.fromScale(0.5, 0.87),
				Size = UDim2.fromScale(0.258, 0.125),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 8,

				Image = "rbxassetid://9531650104",
				ScaleType = Enum.ScaleType.Fit,

				ImageColor3 = Spring(Computed(function()
					return hoveringSubmitButton:get() and hoveringColor or inactiveColor
				end), 20),

				[OnEvent "Activated"] = function()
					if not inputCodeDebounce then
						inputCodeDebounce = true
						nameTextBox:get().TextEditable = false

						local success, returnedString = validCodeCheck:InvokeServer(nameTextBox:get().Text)

						if returnedString then
							if not success then
								textState:set(invalidColor)

								if returnedString == "notValid" then
									nameTextBox:get().Text = "The code entered is not valid! Please try again"
								else
									nameTextBox:get().Text = "This code has already been redeemed! Please enter a different code."
								end
							else
								textState:set(validColor)
								nameTextBox:get().Text = returnedString or ""
							end
						end

						task.wait(3)
						textState:set(neutralColor)
						nameTextBox:get().TextEditable = true
						nameTextBox:get().Text = ""
						inputCodeDebounce = false
					end
				end,

				[OnEvent "MouseEnter"] = function()
					hoveringSubmitButton:set(true)
				end,
			
				[OnEvent "MouseLeave"] = function()
					hoveringSubmitButton:set(false)
				end,

				[Children] = {
					New "TextLabel" {
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.8, 0.8),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 9,

						Text = "Submit",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = Enum.Font.Bodoni,
					}
				}
			},

			--Dash
			New "ImageLabel" {
				Position = UDim2.fromScale(0.5, 0.59),
				Size = UDim2.fromScale(0.8, 0.05),		
				
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 10,
				Image = "rbxassetid://10108600849",
				ScaleType = Enum.ScaleType.Fit,
			},

			--Text box for code
			New "ImageLabel" {
				Name = "NameBox",
				Position = UDim2.fromScale(0.5, 0.7),
				Size = UDim2.fromScale(0.6688, 0.144),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 9,

				Image = "rbxassetid://9722364938",
				ScaleType = Enum.ScaleType.Stretch,

				[Children] = {
					New "TextBox" {
						[Ref] = nameTextBox,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(0.9, 0.8),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						ZIndex = 10,

						PlaceholderText = "Enter Code",
						TextScaled = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						Font = Enum.Font.Bodoni,
						TextColor3 = textState,
					}
				}
			},
			checkPlayer()
		},
	}
end

return Codes