local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local MoneyService = Knit.CreateService({
	Name = "MoneyService",
	Client = {},
})

function MoneyService:KnitStart()
	print("MoneyService started")
end

function MoneyService:KnitInit()
	print("MoneyService initialized")
end

return MoneyService
