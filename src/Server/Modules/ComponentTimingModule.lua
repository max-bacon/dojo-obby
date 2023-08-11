local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise) :: any
local ComponentTimingModule = {}

function ComponentTimingModule._ninjaStar(component:any)
    return Promise.new(function()
        local function fire(collection: {any})
            for _, s in collection do
                s:Fire()
            end
        end
        repeat task.wait() until #component:GetAll() == #CollectionService:GetTagged("NinjaStarObstacle")
    
        local NinjaStarComponentInstances = component:GetAll()
    
        local firstCycle = {}
        local secondCycle = {}
    
        for _, star in NinjaStarComponentInstances :: any do
            if CollectionService:HasTag(star.Instance, "1") then
                table.insert(firstCycle, star)
            else
                table.insert(secondCycle, star)
            end
        end
    
        while true do
            fire(firstCycle)
            Promise.delay(.5):await()
            fire(secondCycle)
            Promise.delay(.5):await()
        end
    end)
end

function ComponentTimingModule.initialize(components: {[string]: any})
    ComponentTimingModule._ninjaStar(components.NinjaStarObstacle)
end

return ComponentTimingModule