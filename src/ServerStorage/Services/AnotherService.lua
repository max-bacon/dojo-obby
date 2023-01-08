local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local AnotherService = Knit.CreateService({
	Name = "AnotherService",
	Client = {},
})

function AnotherService:KnitStart()
	print("AnotherService started")
end

function AnotherService:KnitInit()
	print("AnotherService initialized")
end

return AnotherService
