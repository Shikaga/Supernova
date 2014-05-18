-----------------------------------------------------------------------------------------------
-- Client Lua Script for Supernova
-- Copyright (c) Shikaga. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- Supernova Module Definition
-----------------------------------------------------------------------------------------------
local Supernova = {}
 
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
end
 

-----------------------------------------------------------------------------------------------
-- HelloWorld OnLoad
-----------------------------------------------------------------------------------------------
function Supernova:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("Supernova.xml")
				
	self.MarketplaceCommodity = Apollo.GetAddon("MarketplaceCommodity")
    self:InitializeHooks()

    TradeTicketHandler = Apollo.GetPackage("TradeTicketHandler").tPackage
    Watchlist = Apollo.GetPackage("Watchlist").tPackage
    TradeTicketHandler.xmlDoc = self.xmlDoc

    self.watchlist = Watchlist:new({supernova = self})
    self.tradeTicketHandler = TradeTicketHandler:new()
end

function Supernova:OnSave(eLevel)
	local save = {}
	save.watchlist = self.watchlist:Serialize()
	return save
end

function Supernova:OnRestore(eLevel, tData)
	self.watchlist:Deserialize(tData.watchlist)
end

function Supernova:InitializeHooks()
	self:AddAddCommodityButtons()
end

function Supernova:AddAddCommodityButtons()
	local fnOldHeaderBtnToggle = self.MarketplaceCommodity.OnHeaderBtnToggle
    self.MarketplaceCommodity.OnHeaderBtnToggle = function(tMarketPlaceCommodity)
		marketplaceWindow  = tMarketPlaceCommodity.wndMain
        fnOldHeaderBtnToggle(tMarketPlaceCommodity)
        local children = marketplaceWindow:FindChild("MainScrollContainer"):GetChildren()
        for i, child in ipairs(children) do
            if child:GetText() == "" then
                local x = Apollo.LoadForm(self.xmlDoc, "AddButton", child, self)
            end
        end
        Apollo.LoadForm(self.xmlDoc , "CommodityButtons", marketplaceWindow, self)
    end
end

-----------------------------------------------------------------------------------------------
-- HelloWorldForm Functions
-----------------------------------------------------------------------------------------------

-- when the a Ticket is closed button is clicked
function Supernova:OnToggleWatchlist()
	self.watchlist:OpenWatchlist()
end

-- when the Add Commodity button is clicked
function Supernova:OnAddCommodity( wndHandler, wndControl, eMouseButton )
	local commodityId = tonumber(wndControl:GetParent():GetName());
	self.watchlist:AddCommodityById(commodityId)
end

function Supernova:LaunchTicket(commodity)
	self.tradeTicketHandler:OpenTicket(commodity)
end

-----------------------------------------------------------------------------------------------
-- Utils
-----------------------------------------------------------------------------------------------


function Supernova:PrintMembers(o)
	Print('Printing Members')
	Print('----')
	for key,value in pairs(getmetatable(o)) do
	    Print("found member " .. key);
	end
	Print('----')
end

-----------------------------------------------------------------------------------------------
-- Supernova Instance
-----------------------------------------------------------------------------------------------
local SupernovaInst = Supernova:new()
SupernovaInst:Init()
