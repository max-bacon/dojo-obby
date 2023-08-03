-- Coupling of Tweens and Promises

local Tween = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"))

local TweenService = game:GetService("TweenService")

Tween.TweenInfoPresets = {}

local function applyProps(ins: Instance, props: { [string]: any })
	local anyCast: any = ins -- temp while Luau is fixed
	for prop, val in props do
		anyCast[prop] = val
	end
end

function Tween.new(obj: Instance, info: TweenInfo, props: { [string]: any }, resetOnCancel: boolean?)
	return Promise.new(function(resolve, reject, onCancel)
		local tween = TweenService:Create(obj, info, props)

		local oldProps = {}
		if resetOnCancel then
			local anyCast: any = obj -- temp while Luau is fixed
			for prop, _ in props do
				oldProps[prop] = anyCast[prop]
			end
		end

		if
			onCancel(function()
				print("cancelling")
				tween:Cancel()
				if resetOnCancel then
					applyProps(obj, oldProps)
				else
					applyProps(obj, props)
				end
			end)
		then
			return
		end

		tween.Completed:Connect(resolve)
		tween:Play()
	end)
end

return Tween
