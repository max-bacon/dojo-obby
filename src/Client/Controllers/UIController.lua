local Knit = require(game:GetService("ReplicatedStorage").Utils.Knit)

local Fusion = require(game:GetService("ReplicatedStorage").Utils.Fusion)
local Value, Observer, Computed, ForKeys, ForValues, ForPairs = Fusion.Value, Fusion.Observer, Fusion.Computed, Fusion.ForKeys, Fusion.ForValues, Fusion.ForPairs
local New, Children, OnEvent, OnChange, Out, Ref, Cleanup = Fusion.New, Fusion.Children, Fusion.OnEvent, Fusion.OnChange, Fusion.Out, Fusion.Ref, Fusion.Cleanup
local Tween, Spring = Fusion.Tween, Fusion.Spring

local UIComponentsFolder = script.Parent.Parent.Modules.UIComponents

local UIController = Knit.CreateController({ Name = "UIController" })

local UIComponents = {}

function UIController:Get(name: string)
    return UIComponents[name]
end

function UIController:KnitStart() end

function UIController:KnitInit()
    for _, mod in pairs(UIComponentsFolder) do
        UIComponents[mod.Name] = require(mod)
    end
end

return UIController
