local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local TestController = Knit.CreateController({
	Name = "TestController",
})

function TestController:KnitInit()
	print("TestController initialized")
end

function TestController:KnitStart()
	print("TestController started")
	local TestService = Knit.GetService("TestService")
	TestService:Add(5, 15):andThen(function(value)
		print(value)
	end)
end

return TestController
