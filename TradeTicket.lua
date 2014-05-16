local TradeTicket = {}

function TradeTicket:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	local window = Apollo.LoadForm(TradeTicket.xmlDoc, "TradeTicket", nil, o)
	o.window = window
	o:SetTextFields()
	return o
end

function TradeTicket:SetTextFields()
	self.window:FindChild("CommodityName"):SetText(self.commodity:GetName())
	self.window:FindChild("Top1Value"):SetText(self.commodity.buy1)
	self.window:FindChild("Top10Value"):SetText(self.commodity.buy10)
	self.window:FindChild("Top50Value"):SetText(self.commodity.buy50)
end

function TradeTicket:OnCloseTicket()
	self.window:Close()
end

Apollo.RegisterPackage(TradeTicket, "TradeTicket", 1, {})