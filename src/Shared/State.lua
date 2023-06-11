local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

export type State = {
    CheckpointTransparency: Fusion.Value<number>
}

return function(): State
    local checkpointTransparency = Fusion.Value(0)
    return {
        CheckpointTransparency = checkpointTransparency
    }
end
