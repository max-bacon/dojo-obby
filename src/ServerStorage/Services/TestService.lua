local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local TestService = Knit.CreateService({
	Name = "TestService",
	Client = {},
})

function TestService.Client:Add(_, num1, num2)
	return num1 + num2
end

function TestService:KnitStart()
	print("TestService started")
end

function TestService:KnitInit()
	print("TestService initialized")
end

return TestService
