local IntegratedWatchlistRow = {}

function IntegratedWatchlistRow:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o:Init()
	return o
end

function IntegratedWatchlistRow:Init()
	local rowWindow = Apollo.LoadForm(self.supernova.xmlDoc , "IntegratedWatchlistRow", self.watchlist:GetGrid(), self)
	rowWindow:FindChild("CommodityName"):SetText(self.commodity:GetName())
	rowWindow:FindChild("BuyPrice"):SetText(self.commodity.buy1)
	rowWindow:FindChild("SellPrice"):SetText(self.commodity.sell1)
end

function IntegratedWatchlistRow:OnLaunchTicket( wndHandler, wndControl, eMouseButton )
	self.supernova:LaunchTicket(self.commodity)
end

function IntegratedWatchlistRow:OnCloseButtonClicked(wndHandler, wndControl, eMouseButton )
	self.watchlist:RemoveCommodity(self.commodity)
end

Apollo.RegisterPackage(IntegratedWatchlistRow, "IntegratedWatchlistRow", 1, {})