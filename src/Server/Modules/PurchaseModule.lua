local MarketplaceService = game:GetService("MarketplaceService")

local PurchaseModule = {}

local RobuxReactionModule = require(script.Parent.RobuxReactionModule)

local Gamepasses = {
	[21421442] = RobuxReactionModule.Sensei,
}

local Products = {}

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, pass_id, was_purchased)
	print(pass_id, was_purchased)
	if not was_purchased then
		return
	end

	Gamepasses[pass_id](player)
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, pass_id, was_purchased)
	print(pass_id, was_purchased)
	if not was_purchased then
		return
	end

	Products[pass_id](player)
end)

return PurchaseModule
