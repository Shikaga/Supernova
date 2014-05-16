local TradeTicketHandler = {}

function TradeTicketHandler:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self


    TradeTicket = Apollo.GetPackage("TradeTicket").tPackage
    TradeTicket.xmlDoc = self.xmlDoc

	return o
end

function TradeTicketHandler:OpenTicket()
	local ticket = TradeTicket:new()
end

Apollo.RegisterPackage(TradeTicketHandler, "TradeTicketHandler", 1, {})