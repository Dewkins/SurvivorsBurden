local addonName, addonTable = ...
local LDB = LibStub("LibDataBroker-1.1")
local LDI = LibStub("LibDBIcon-1.0")

local dataObject = LDB:NewDataObject("SurvivorsBurden", {
    type = "launcher",
    text = "Survivor's Burden",
    icon = "Interface\\Icons\\ability_hunter_camouflage",
    OnClick = function(_, button)
        if button == "LeftButton" then
            addonTable.enabled = not addonTable.enabled
            if addonTable.enabled then
                addonTable.frame:Show()
            else
                addonTable.frame:Hide()
            end
        elseif button == "RightButton" then
            if Settings and Settings.OpenToCategory then
                Settings.OpenToCategory("Survivor's Burden")
            elseif InterfaceOptionsFrame_OpenToCategory then
                InterfaceOptionsFrame_OpenToCategory("Survivor's Burden")
                InterfaceOptionsFrame_OpenToCategory("Survivor's Burden") -- FFS Blizzard
            end
        end
    end,
    OnTooltipShow = function(tt)
        tt:AddLine("Survivor's Burden")
        tt:AddLine("\n")
        tt:AddLine("|cff00ff00Left-Click:|r Toggle Addon")
        tt:AddLine("|cff00ff00Right-Click:|r Open Settings")
    end,
})

function addonTable.RegisterMinimapButton()
    if not LDI:IsRegistered("SurvivorsBurden") then
        LDI:Register("SurvivorsBurden", dataObject, SB_MinimapDB)
    end
end

function addonTable.ToggleMinimapButton(state)
    if state == "on" then
        SB_MinimapDB.minimap.hide = false
        LDI:Show("SurvivorsBurden")
    elseif state == "off" then
        SB_MinimapDB.minimap.hide = true
        LDI:Hide("SurvivorsBurden")
    end
end
