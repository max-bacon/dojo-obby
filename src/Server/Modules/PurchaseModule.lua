local MarketplaceService = game:GetService("MarketplaceService")

local PurchaseModule = {}

local GamepassModule = require(script.Parent.GamepassModule)

local Gamepasses = {
    [21421442] = GamepassModule.Sensei
}

function PurchaseModule.promptGamepass(player: Player, id: number, callback: (result: boolean) -> ())
    MarketplaceService:PromptGamePassPurchase(player, id)
end

function PurchaseModule.promptDevProduct(player: Player, id: number, callback: (result: boolean) -> ())
    MarketplaceService:PromptGamePassPurchase(player, id)
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, pass_id, was_purchased)
    if not was_purchased then return end

    Gamepasses[pass_id](player)
end)

return PurchaseModule