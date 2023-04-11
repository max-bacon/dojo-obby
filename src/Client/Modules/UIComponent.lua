local UIComponent = {}
UIComponent.__index = UIComponent


function UIComponent.new()
    local self = setmetatable({}, UIComponent)
    return self
end


function UIComponent:Destroy()
    
end


return UIComponent
