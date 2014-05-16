local TradeTicket = {}

local BUY = 0
local SELL = 1

function TradeTicket:new(o)
 	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	local window = Apollo.LoadForm(TradeTicket.xmlDoc, "TradeTicket", nil, o)
	o.window = window
	o:Init()
	return o
end

function TradeTicket:Init()
	self:DisableExecuteButton()
	self.buySell = BUY

	self.volume = 1
	self.price = 0

	self:SetTextFields()

	self:Validate()
end

function TradeTicket:SetTextFields()
	self.window:FindChild("CommodityName"):SetText(self.commodity:GetName())
	self:SetBuyPrices()
end

function TradeTicket:SetBuyPrices()
	self.window:FindChild("Top1Value"):SetText(self.commodity.buy1)
	self.window:FindChild("Top10Value"):SetText(self.commodity.buy10)
	self.window:FindChild("Top50Value"):SetText(self.commodity.buy50)
end

function TradeTicket:SetSellPrices()
	self.window:FindChild("Top1Value"):SetText(self.commodity.sell1)
	self.window:FindChild("Top10Value"):SetText(self.commodity.sell10)
	self.window:FindChild("Top50Value"):SetText(self.commodity.sell50)
end

function TradeTicket:OnListInputNumberChanged()
	self.volume = self.window:FindChild("TradeWindow"):FindChild("ListInputNumber"):GetText()
	self:Validate()
end

function TradeTicket:OnListInputPriceAmountChanged()
	self.price = math.max(0, tonumber(self.window:FindChild("TradeWindow"):FindChild("ListInputPrice"):GetAmount() or 0))
	self:Validate()
end

function TradeTicket:OnListInputNumberDownBtn()
	Print("Down")
end

function TradeTicket:OnListInputNumberUpBtn()
	Print("Up")
end

function TradeTicket:OnCloseTicket()
	self.window:Close()
end

function TradeTicket:EnableExecuteButton()
	self.window:FindChild("ExecuteButton"):Enable(true)
end

function TradeTicket:DisableExecuteButton()
	self.window:FindChild("ExecuteButton"):Enable(false)
end

function TradeTicket:OnBuySellToggle()
	if self.buySell == BUY then
		self.buySell = SELL
		self.window:FindChild("BuySellButton"):SetText("Sell")
		self:SetSellPrices()
	else
		self.buySell = BUY
		self.window:FindChild("BuySellButton"):SetText("Buy")
		self:SetBuyPrices()
	end
	self:Validate()
end

function TradeTicket:Validate()
	local totalPrice = self.price * self.volume
	local text = "Set a valid price and volume"
	if totalPrice > 0 then
		text = "You are going to " .. self:BuyOrSellString() .. " " .. self.volume .. " [" .. self.commodity:GetName() .. "] for " .. self.price .. "c each, for total price of " .. totalPrice .. "c"
		self:EnableExecuteButton()
	else
		self:DisableExecuteButton()
	end
	self.window:FindChild("TradeWindow"):FindChild("SummaryText"):SetText(text)
end

function TradeTicket:BuyOrSellString()
	if self.buySell == BUY then
		return "Buy"
	else
		return "Sell"
	end
end

Apollo.RegisterPackage(TradeTicket, "TradeTicket", 1, {})