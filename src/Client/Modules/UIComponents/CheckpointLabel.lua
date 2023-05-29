local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local TweenService = game:GetService("TweenService")
local Images = require(ReplicatedStorage.Shared.Modules.Images)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Promise = require(ReplicatedStorage.Packages.Promise)

local Observer = Fusion.Observer
local New, Cleanup = Fusion.New, Fusion.Cleanup

local CheckpointTextImage = Images.UI.CheckpointText
local OGImageDim = Vector2.new(1093, 254)

local function adjust(element, props)
	for prop, val in pairs(props) do
		element[prop] = val
	end
end

local function checkpointText(props)
	local trove = Trove.new()

	local checkText = New("ImageLabel")({
		Name = "CheckpointLabel",
		Image = CheckpointTextImage,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.276, 0.2),
		Size = UDim2.fromScale(0, 0.191),
		AnchorPoint = Vector2.new(0, 0.5),
		ImageRectSize = Vector2.new(0, OGImageDim.Y),
		ImageColor3 = Color3.fromRGB(67, 0, 0),
		ZIndex = 2
	})

	local checkShadow = New("ImageLabel")({
		Name = "CheckpointShadow",
		Image = CheckpointTextImage,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.28, 0.205),
		Size = UDim2.fromScale(0, 0.191),
		AnchorPoint = Vector2.new(0, 0.5),
		ImageRectSize = Vector2.new(0, OGImageDim.Y),
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 1
	})

	local last

	trove:Add(props.Event:Connect(function()
		last = Promise.new(function(resolve, _, onCancel)
			local TI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local textTween = TweenService:Create(checkText, TI, { ImageTransparency = 1 })
			local shadowTween = TweenService:Create(checkShadow, TI, { ImageTransparency = 1 })

			local disconObs
			local canceled = false

			if
				onCancel(function()
					last = nil
					canceled = true
					textTween:Cancel()
					shadowTween:Cancel()
					if disconObs then
						disconObs()
					end

					checkText.ImageTransparency = 0
					checkShadow.ImageTransparency = 0
				end)
			then
				return
			end

			disconObs = Observer(props.KatanaXPos):onChange(function()
				if props.KatanaXPos:get().X > checkText.AbsoluteSize.Y * (OGImageDim.X / OGImageDim.Y) then
					disconObs()
				end
				local calc = math.clamp(
					props.KatanaXPos:get().X - checkText.AbsolutePosition.X,
					0,
					checkText.AbsoluteSize.Y * (OGImageDim.X / OGImageDim.Y)
				)

				local sizeCalc = UDim2.new(0, calc, checkText.Size.Y.Scale, 0)
				local rectCalc = Vector2.new(calc * OGImageDim.Y / checkText.AbsoluteSize.Y, OGImageDim.Y)

				adjust(checkText, {
					Size = sizeCalc,
					ImageRectSize = rectCalc,
				})

				adjust(checkShadow, {
					Size = sizeCalc,
					ImageRectSize = rectCalc,
				})

				-- print(checkText.ImageRectSize.X / checkText.ImageRectSize.Y)
				-- print(checkText.Size.X.Offset / checkText.Size.Y.Scale / 1080)
			end)
			print("test2")
			task.wait(props.DelayTime + props.Time)
			if canceled then
				return
			end
			print("tesst")
			textTween:Play()
			shadowTween:Play()

			textTween.Completed:Wait()

			adjust(checkText, {
				Size = UDim2.new(0, 0, checkText.Size.Y.Scale, 0),
				ImageRectSize = Vector2.new(0, checkText.ImageRectSize.Y),
			})

			adjust(checkShadow, {
				Size = UDim2.new(0, 0, checkShadow.Size.Y.Scale, 0),
				ImageRectSize = Vector2.new(0, checkShadow.ImageRectSize.Y),
			})

			checkText.ImageTransparency = 0
			checkShadow.ImageTransparency = 0

			resolve()
		end)

		last:andThen(function()
			last = nil
		end)

		last:catch(function(err)
			print(err)
		end)
	end))

	trove:Add(Observer(props.KatanaXPos):onChange(function()
		local calc = math.clamp(
			props.KatanaXPos:get().X - checkText.AbsolutePosition.X,
			0,
			checkText.AbsoluteSize.Y * (OGImageDim.X / OGImageDim.Y)
		)

		local sizeCalc = UDim2.new(0, calc, checkText.Size.Y.Scale, 0)
		local rectCalc = Vector2.new(calc * OGImageDim.Y / checkText.AbsoluteSize.Y, OGImageDim.Y)

		adjust(checkText, {
			Size = sizeCalc,
			ImageRectSize = rectCalc,
		})

		adjust(checkShadow, {
			Size = sizeCalc,
			ImageRectSize = rectCalc,
		})

		-- print(checkText.ImageRectSize.X / checkText.ImageRectSize.Y)
		-- print(checkText.Size.X.Offset / checkText.Size.Y.Scale / 1080)
	end))

	return checkText, checkShadow
end

return checkpointText
