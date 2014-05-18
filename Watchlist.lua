local Watchlist = {}

function Watchlist:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o:Init()
	return o
end

function Watchlist:Init()
	CommodityHandler = Apollo.GetPackage("CommodityHandler").tPackage
	WatchlistRow = Apollo.GetPackage("WatchlistRow").tPackage
    self.commodityHandler = CommodityHandler:new({supernova = self.supernova})

    Apollo.RegisterEventHandler("CommodityInfoResults", "OnCommodityInfoResults", self)
	self.wndMain = Apollo.LoadForm(self.supernova.xmlDoc, "HelloWorldForm", nil, self)
end

function Watchlist:AddCommodityById( commodityId )
	local commodity = self.commodityHandler:AddCommodity(commodityId)

	self:DrawCommodities()
	self:OpenWatchlist()
end

function Watchlist:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self.commodityHandler:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self:DrawCommodities()
end

function Watchlist:DrawCommodities()
	if (self.wndMain) then
		local wndGrid = self:GetGrid()
		if (wndGrid) then
			wndGrid:DestroyChildren()
			for key,value in pairs(self.commodityHandler.commodities) do
				local row = WatchlistRow:new({watchlist = self, supernova = self.supernova, commodity = value})
			end
			wndGrid:ArrangeChildrenVert(0)
		end
	end
end

function Watchlist:GetGrid()
	return self.wndMain:FindChild("Grid")
end

function Watchlist:RemoveCommodity(commodity)
	self.commodityHandler:RemoveCommodity(commodity)
	self:DrawCommodities()
end

function Watchlist:OpenWatchlist()
	self.commodityHandler:RequestCommodityInfo()
	self:DrawCommodities()
	self.wndMain:Invoke()
end

function Watchlist:OnOK()
	self.wndMain:Close() -- hide the window
end

function Watchlist:OnCancel()
	self.wndMain:Close() -- hide the window
end

function Watchlist:Serialize()
	return self.commodityHandler:Serialize()
end

function Watchlist:Deserialize(data)
	self.commodityHandler:Deserialize(data)
end



Apollo.RegisterPackage(Watchlist, "Watchlist", 1, {})