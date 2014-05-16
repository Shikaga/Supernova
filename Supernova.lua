-----------------------------------------------------------------------------------------------
-- Client Lua Script for Supernova
-- Copyright (c) Shikaga. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- Supernova Module Definition
-----------------------------------------------------------------------------------------------
local Supernova = {} 
local Commodity
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
local marketplaceWindow = nil
local x = 1
local y = 0
local restoreCalled = false
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function Supernova:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

function Supernova:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = "Supernova"
	local tDependencies = {"MarketplaceCommodity", "CommodityHandler", "Commodity", "TradeTicket", "TradeTicketHandler"} 
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
    Apollo.RegisterEventHandler("CommodityInfoResults", "OnCommodityInfoResults", self)
end
 

-----------------------------------------------------------------------------------------------
-- HelloWorld OnLoad
-----------------------------------------------------------------------------------------------
function Supernova:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("Supernova.xml")
	self.wndMain = Apollo.LoadForm(self.xmlDoc, "HelloWorldForm", nil, self)
				
	self.MarketplaceCommodity = Apollo.GetAddon("MarketplaceCommodity")
    self:InitializeHooks()

    Commodity = Apollo.GetPackage("Commodity").tPackage
    CommodityHandler = Apollo.GetPackage("CommodityHandler").tPackage
    TradeTicketHandler = Apollo.GetPackage("TradeTicketHandler").tPackage
    TradeTicketHandler.xmlDoc = self.xmlDoc

    self.commodityHandler = CommodityHandler:new()
    self.tradeTicketHandler = TradeTicketHandler:new()
end


function Supernova:OnSave(eLevel)
	local save = {}
	save.commodities = self.commodityHandler:Serialize()
	return save
end

function Supernova:OnRestore(eLevel, tData)
	self.commodityHandler:Deserialize(tData.commodities)
end

function Supernova:InitializeHooks()
	-- Handle MarketplaceCommodity appearance or change
	local fnOldHeaderBtnToggle = self.MarketplaceCommodity.OnHeaderBtnToggle
    self.MarketplaceCommodity.OnHeaderBtnToggle = function(tMarketPlaceCommodity)
		marketplaceWindow  = tMarketPlaceCommodity.wndMain
        fnOldHeaderBtnToggle(tMarketPlaceCommodity)
        local children = marketplaceWindow:FindChild("MainScrollContainer"):GetChildren()
        for i, child in ipairs(children) do
            if child:GetText() == "" then
                local x = self:LoadByName("AddButton", child)
            end
        end
    end
end

function Supernova:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self.commodityHandler:OnCommodityInfoResults(nItemId, tStats, tOrders)
	self:DrawCommodities()
end

function Supernova:DrawCommodities()
	if (self.wndMain) then
		local wndGrid = self.wndMain:FindChild("Grid")
		if (wndGrid) then
			wndGrid:DestroyChildren()
			for key,value in pairs(self.commodityHandler.commodities) do
				local row = self:LoadByName("Row", wndGrid , "ExampleText")
				row:FindChild("CommodityName"):SetText(value:GetName())
				row:FindChild("BuyPrice"):SetText(value.buy1)
				row:FindChild("SellPrice"):SetText(value.sell1)
			end
			wndGrid:ArrangeChildrenVert(0)
		end
	end
end

-----------------------------------------------------------------------------------------------
-- HelloWorldForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function Supernova:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
function Supernova:OnCancel()
	self.wndMain:Close() -- hide the window
end

-- when the a Ticket is closed button is clicked
function Supernova:OnCloseTicket()
	Print('Close Ticket invoked')
end

-- when the Add Commodity button is clicked
function Supernova:OnAddCommodity( wndHandler, wndControl, eMouseButton )
	local commodityId = tonumber(wndControl:GetParent():GetName());
	local commodity
	commodity = self.commodityHandler:AddCommodity(commodityId)	
    Print("Statistics requested for " .. commodity:GetId() .. " " .. commodity:GetName())
	MarketplaceLib.RequestCommodityInfo(commodity:GetId())

	self:DrawCommodities()
	self.wndMain:Invoke()
end

function Supernova:LaunchTicket( wndHandler, wndControl, eMouseButton )
	self.tradeTicketHandler:OpenTicket()
end


-----------------------------------------------------------------------------------------------
-- Utils
-----------------------------------------------------------------------------------------------

function Supernova:LoadByName(strForm, wndParent)
	wndNew = Apollo.LoadForm(self.xmlDoc , strForm, wndParent, self)
	return wndNew
end

function Supernova:PrintMembers(o)
	Print('Printing Members')
	Print('----')
	for key,value in pairs(o) do
	    Print("found member " .. key);
	end
	Print('----')
end

-----------------------------------------------------------------------------------------------
-- Supernova Instance
-----------------------------------------------------------------------------------------------
local SupernovaInst = Supernova:new()
SupernovaInst:Init()
