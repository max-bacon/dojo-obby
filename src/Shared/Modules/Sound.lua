local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Sounds = require(Assets:WaitForChild("Sounds"))

local Promise = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"))

local Sound = {}

function Sound.new(soundId: string, parent: Instance, props: { [string]: any }?)
	return Promise.new(function(resolve, reject, onCancel)
		local sound = parent:FindFirstChildOfClass("Sound") or Instance.new("Sound")
		sound.Parent = parent
		sound.SoundId = Sounds[soundId] or soundId

		if props then
			for name, value in props do
				sound[name] = value
			end
		end

		local endedEvent

		if onCancel(function()
			sound:Destroy()
			endedEvent:Disconnect()
		end) then
			return
		end

		endedEvent = sound.Ended:Connect(function()
			resolve()
			sound:Destroy()
		end)
		sound:Play()
	end)
end

return Sound
