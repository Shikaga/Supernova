local Watchlist = {}

function Watchlist:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o:Init()
	o.x = "NPOE"
	return o
end

function Watchlist:Init()
	CommodityHandler = Apollo.GetPackage("CommodityHandler").tPackage
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
		local wndGrid = self.wndMain:FindChild("Grid")
		if (wndGrid) then
			wndGrid:DestroyChildren()
			for key,value in pairs(self.commodityHandler.commodities) do
				local row = Apollo.LoadForm(self.supernova.xmlDoc , "Row", wndGrid, value)
				row:FindChild("CommodityName"):SetText(value:GetName())
				row:FindChild("BuyPrice"):SetText(value.buy1)
				row:FindChild("SellPrice"):SetText(value.sell1)
			end
			wndGrid:ArrangeChildrenVert(0)
		end
	end
end

function Watchlist:OpenWatchlist()
	--self.commodityHandler:RequestCommodityInfo()
	Print(self.x)
	Print("OpenWatchlist")
	self:DrawCommodities()
		self.wndMain:Invoke()
end

-- when the OK button is clicked
function Watchlist:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
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