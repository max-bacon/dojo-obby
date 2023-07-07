local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PurchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")

local PurchaseModule = {}

local RobuxReactionModule = require(script.Parent.RobuxReactionModule)

type Format = {
	[number]: (Player) -> boolean,
}

local Gamepasses: Format = {
	[21421442] = RobuxReactionModule.Sensei,
}

local Products: Format = {
	[1558374721] = RobuxReactionModule.SkipStage,
}

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, pass_id, was_purchased)
	print(pass_id, was_purchased)
	if not was_purchased then
		return
	end

	Gamepasses[pass_id](player)
end)

MarketplaceService.ProcessReceipt = function(receiptInfo: { [string]: any })
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased = false
	local success, result, errorMessage

	success, errorMessage = pcall(function()
		purchased = PurchaseHistoryStore:GetAsync(playerProductKey)
	end)
	-- If purchase was recorded, the product was already granted
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		error("Data store error:" .. errorMessage)
	end

	-- Determine if the product was already granted by checking the data store

	local success2, isPurchaseRecorded: any? = pcall(function()
		return PurchaseHistoryStore:UpdateAsync(playerProductKey, function(alreadyPurchased): any
			if alreadyPurchased then
				return true
			end

			-- Find the player who made the purchase in the server
			local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
			if not player then
				-- The player probably left the game
				-- If they come back, the callback will be called again
				return nil
			end

			local handler = Products[receiptInfo.ProductId]

			local success: any?, result: any? = pcall(handler, player)
			-- If granting the product failed, do NOT record the purchase in datastores.
			if not success or not result then
				error(
					"Failed to process a product purchase for ProductId: "
						.. tostring(receiptInfo.ProductId)
						.. " Player: "
						.. tostring(player)
						.. " Error: "
						.. tostring(result)
				)
				return nil
			end

			-- Record the transcation in purchaseHistoryStore.
			return true
		end)
	end)

	if not success2 then
		error("Failed to process receipt due to data store error.")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	elseif isPurchaseRecorded == nil then
		-- Didn't update the value in data store.
		return Enum.ProductPurchaseDecision.NotProcessedYet
	else
		-- IMPORTANT: Tell Roblox that the game successfully handled the purchase
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

return PurchaseModule
