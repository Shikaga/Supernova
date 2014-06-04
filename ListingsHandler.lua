local ListingHandlerRow = {}

function ListingHandlerRow:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function ListingHandlerRow:LaunchTicket()
	self.supernova:LaunchTicket(self.commodity)
end


local ListingsHandler = {}

function ListingsHandler:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	
	o:Init()
	o.listingWindowMap = {}
    Apollo.RegisterEventHandler("CommodityInfoResults", "OnCommodityInfoResults", o)

	return o
end

function ListingsHandler:Init()
	--local ticket = TradeTicket:new({commodity = commodity})
	local CommodityHandler = Apollo.GetPackage("CommodityHandler").tPackage
    self.commodityHandler = CommodityHandler:new({supernova = self.supernova})
	self.MarketplaceListings = Apollo.GetAddon("MarketplaceListings")

	local fnOldRedrawData = self.MarketplaceListings.FactoryProduce
	self.MarketplaceListings.FactoryProduce = function(arg1, arg2, arg3, arg4) 
		local commodityId = arg4:GetItem():GetItemId()

		local wnd = fnOldRedrawData(arg1, arg2, arg3, arg4)
		local listingWnd = Apollo.LoadForm(self.xmlDoc, "ListingMarketPrice", wnd, self)
		self.listingWindowMap[commodityId] = listingWnd
		local commodity = self:AddCommodity(listingWnd, commodityId)

		lhr = ListingHandlerRow:new({supernova = self.supernova, commodity = commodity})
		Apollo.LoadForm(self.xmlDoc, "LaunchTicketButton", wnd, lhr)
		return wnd
	end
end

function ListingsHandler:AddCommodity(wnd, commodityId)
	local commodity = self.commodityHandler:AddCommodity(commodityId)
	self.commodityHandler:RequestCommodityInfo()
	return commodity
end


function ListingsHandler:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self.commodityHandler:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self:UpdateCommodities()
end

function ListingsHandler:UpdateCommodities()
	for _,value in pairs(self.commodityHandler.commodities) do
		local listingWnd = self.listingWindowMap[value:GetId()]
		listingWnd:FindChild("SellPrice"):SetText(value.sell1)
		listingWnd:FindChild("BuyPrice"):SetText(value.buy1)
	end
end

Apollo.RegisterPackage(ListingsHandler, "ListingsHandler", 1, {})