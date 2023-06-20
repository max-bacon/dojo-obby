local ReplicatedStorage = game:GetService("ReplicatedStorage")
local target = ReplicatedStorage:WaitForChild("FusionMaterial")

local Packages = ReplicatedStorage.Packages

local Trove = require(Packages.Trove)
local Rewire = require(Packages.Rewire)
local State = require(ReplicatedStorage.State)

type State = State.State

local Interface = ReplicatedStorage.Interface

local hotReloader = Rewire.HotReloader.new()

local components = {}
for _, mod in target:GetChildren() do
	components[mod.Name] = mod
end

local state
local ui: (state: State, components: { [string]: () -> () }) -> ()

local maid = Trove.new()

local function cleanupFunction(module, context): ()
	--context.originalModule:Destroy()
end

local function hotReload()
	if not state or not ui then
		return
	end
	maid:Clean()
	maid:Add(ui(state(), components))
end

hotReloader:listen(Interface, function(module)
	ui = require(module) :: any

	hotReload()
end, cleanupFunction)

hotReloader:scan(target, function(module)
	components[module.Name] = require(module) :: any

	hotReload()
end, cleanupFunction)

hotReloader:listen(ReplicatedStorage.State, function(module)
	state = require(module) :: any

	hotReload()
end, cleanupFunction)
