local Knit = require(game:GetService("ReplicatedStorage").Utils.Knit)

local ObbyService = Knit.CreateService({
	Name = "ObbyService",
	Client = {},
})

function ObbyService:KnitStart() end

function ObbyService:KnitInit() end

return ObbyService
