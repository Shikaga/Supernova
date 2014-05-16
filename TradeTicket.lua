local TradeTicket = {}

function TradeTicket:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	self.window = Apollo.LoadForm(TradeTicket.xmlDoc, "TradeTicket", nil, self)
	self.window:Invoke()
	return o
end

function TradeTicket:OnCloseTicket()
	self.window:Close()
end

Apollo.RegisterPackage(TradeTicket, "TradeTicket", 1, {})