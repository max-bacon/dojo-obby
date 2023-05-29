local Player = game:GetService("Players").LocalPlayer

-- Target
local targetUI = { Player.PlayerScripts:WaitForChild("FusionMaterial").NewLevelNotification }

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local State = require(script.Parent.State)

local Trove = require(Packages.Trove)
local Rewire = require(Packages.Rewire)

local hotReloader = Rewire.HotReloader.new()

local state
local ui = {}

local maid = Trove.new()

local function blankFunction() end

local function hotReload()
    print(state, ui)
	if not state or not ui then
		return
	end
	print("Change")
	maid:Clean()
	for _, s in ui do
		maid:Add(s.Construct(state()))
	end
end

for i, s in targetUI do
	hotReloader:listen(s, function(module)
		ui[i] = require(s)

		hotReload()
	end, blankFunction)
end

hotReloader:listen(script.Parent.State, function(module)
	state = require(module)

	hotReload()
end, blankFunction)
