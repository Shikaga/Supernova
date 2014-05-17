local Commodity = {}

function Commodity:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	self.item = Item.GetDataFromId(o.id)
	self.buy1 = 'undefined'
	self.buy10 = 'undefined'
	self.buy50 = 'undefined'
	self.sell1 = 'undefined'
	self.sell10 = 'undefined'
	self.sell50 = 'undefined'
	return o
end

function Commodity:GetId()
	return self.id
end

function Commodity:GetName()
	return Item.GetDataFromId(self.id):GetName() or "Undefined"
end

function Commodity:GetIcon()
	return Item.GetDataFromId(self.id):GetIcon() or "Undefined"
end

function Commodity:UpdateTStats(tStats)
	self.sell1 = tStats.arBuyOrderPrices[1].monPrice:GetAmount()
	self.sell10 = tStats.arBuyOrderPrices[2].monPrice:GetAmount()
	self.sell50 = tStats.arBuyOrderPrices[3].monPrice:GetAmount()
    self.buy1 = tStats.arSellOrderPrices[1].monPrice:GetAmount()
    self.buy10 = tStats.arSellOrderPrices[2].monPrice:GetAmount()
    self.buy50 = tStats.arSellOrderPrices[3].monPrice:GetAmount()
end

function Commodity:LaunchTicket( wndHandler, wndControl, eMouseButton )
	self.supernova:LaunchTicket(self)
end

Apollo.RegisterPackage(Commodity, "Commodity", 1, {})