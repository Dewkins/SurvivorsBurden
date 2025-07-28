local addonName, addonTable = ...

-- Base UI Settings
addonTable.baseWidth = 350
addonTable.baseHeight = 140
addonTable.baseFontSize = 12
addonTable.uiScale = addonTable.uiScale or 1.0  -- Default scale factor

-- Create Main Frame
local frame = CreateFrame("Frame", "SurvivorsBurdenFrame", UIParent, "BackdropTemplate")
addonTable.frame = frame
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Backdrop
frame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(0, 0, 0, 0.85)

-- Title
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetText("Survivor's Burden")

-- Labels & Values
local labels = { "Hunger:", "Thirst:", "Fatigue:", "Hygiene:" , "Bladder:"}
addonTable.rows = {}

for i, stat in ipairs(labels) do
    local row = {}
    row.label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.value = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.label:SetText(stat)
    row.value:SetText("...")
    addonTable.rows[i] = row
end

-- Dynamic Scaling
function addonTable.ApplyUISettings()
    if not addonTable.frame or not addonTable.charData or not addonTable.charData.config then return end

    local scale = addonTable.uiScale
    local width = addonTable.baseWidth * scale
    local fontSize = math.floor(addonTable.baseFontSize * scale)
    local extraWidth = addonTable.indepthMode and 20 or 0
    frame:SetWidth(width + extraWidth)

    -- Title font & position
    title:SetFont(select(1, title:GetFont()), fontSize + 4)
    title:ClearAllPoints()
    title:SetPoint("TOP", frame, "TOP", 0, -(fontSize))

    -- Layout settings
    local labelWidth = 60 * scale
    local valueOffset = 20
    local valueStartX = labelWidth + valueOffset
    local topPadding = fontSize * 4
    local rowSpacing = fontSize + 5
    local yOffset = -topPadding

    local visibleRows = 0
    local lastVisibleRow = nil

    for i, row in ipairs(addonTable.rows) do
        local statEnabled = (i == 1 and addonTable.charData.config.hungerEnabled)
                         or (i == 2 and addonTable.charData.config.thirstEnabled)
                         or (i == 3 and addonTable.charData.config.fatigueEnabled)
                         or (i == 4 and addonTable.charData.config.hygieneEnabled)
                         or (i == 5 and addonTable.charData.config.bladderEnabled)


         if statEnabled then
            row.label:Show()
            row.value:Show()
            visibleRows = visibleRows + 1
            
            row.label:SetFont(select(1, row.label:GetFont()), fontSize)
            row.value:SetFont(select(1, row.value:GetFont()), fontSize)
            
            row.label:ClearAllPoints()
            row.value:ClearAllPoints()
            
            -- Position label
            if lastVisibleRow == nil then
                row.label:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, yOffset)
            else
                row.label:SetPoint("TOPLEFT", lastVisibleRow.label, "BOTTOMLEFT", 0, -rowSpacing)
            end

            -- Position value at same row level
            row.value:SetPoint("TOPLEFT", row.label, "TOPLEFT", valueStartX - 10, 0)
            
            -- Fixed widths
            row.label:SetWidth(labelWidth)
            row.label:SetJustifyH("LEFT")
            row.value:SetJustifyH("LEFT")
            row.value:SetWidth(width - valueStartX)

            lastVisibleRow = row
        else
            row.label:Hide()
            row.value:Hide()
        end
    end

-- If no rows visible
    if visibleRows == 0 then
        if not addonTable.noStatsText then
            addonTable.noStatsText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            addonTable.noStatsText:SetJustifyH("CENTER")
        end

        -- Apply scaled font
        addonTable.noStatsText:SetFont(select(1, addonTable.noStatsText:GetFont()), fontSize + 4)
        addonTable.noStatsText:SetText("You're free of worldly burdens... for now.")
        addonTable.noStatsText:SetWidth(width - 20)

        addonTable.noStatsText:Show()
        addonTable.noStatsText:ClearAllPoints()
        addonTable.noStatsText:SetPoint("CENTER", frame, "CENTER", 0, -10)
    else
        if addonTable.noStatsText then
            addonTable.noStatsText:Hide()
        end
    end

    -- Dynamically calculate frame height
    local totalHeight = (fontSize * 6) + (visibleRows * (fontSize + 10)) + 15
    frame:SetHeight(totalHeight)
end

-- Initial UI Apply
addonTable.ApplyUISettings()
frame:Show()

-- Severity Icons
local function GetSeverityIcon(value)
    if value > 75 then return "|TInterface\\COMMON\\Indicator-Green:12|t"
    elseif value > 50 then return "|TInterface\\COMMON\\Indicator-Yellow:12|t"
    elseif value > 25 then return "|TInterface\\RAIDFRAME\\ReadyCheck-Waiting:12|t"
    elseif value > 10 then return "|TInterface\\COMMON\\Indicator-Red:12|t"
    else return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:12|t" end
end

-- Status Text
function addonTable.GetStatusText(value, type)
    if type == "Hunger" then
        if value > 75 then return "|cff00FF00You feel comfortably full.|r"
        elseif value > 50 then return "|cffFFFF00You feel peckish."
        elseif value > 25 then return "|cffFFD700Your stomach growls with hunger.|r"
        elseif value > 10 then return "|cffFF8000Hunger gnaws at your insides.|r"
        else return "|cffFF0000You feel faint. Starvation sets in.|r"
        end
    elseif type == "Thirst" then
        if value > 75 then return "|cff00FF00You feel well hydrated.|r"
        elseif value > 50 then return "|cffFFFF00Your mouth feels dry."
        elseif value > 25 then return "|cffFFD700You thirst for water.|r"
        elseif value > 10 then return "|cffFF8000Your throat burns with thirst.|r"
        else return "|cffFF0000Your lips crack and your vision blurs.|r"
        end
    elseif type == "Fatigue" then
        if value > 75 then return "|cff00FF00You feel rested and alert.|r"
        elseif value > 50 then return "|cffFFFF00Your body aches for rest."
        elseif value > 25 then return "|cffFFD700Fatigue slows your steps.|r"
        elseif value > 10 then return "|cffFF8000Your eyelids fight to stay open.|r"
        else return "|cffFF0000You stumble from exhaustion.|r"
        end
    elseif type == "Hygiene" then
        if value > 75 then return "|cff00FF00You're clean and presentable.|r"
        elseif value > 50 then return "|cffFFFF00You smell faintly of sweat."
        elseif value > 25 then return "|cffFFD700Grime clings to your skin.|r"
        elseif value > 10 then return "|cffFF8000The stench makes others recoil.|r"
        else return "|cffFF0000Flies buzz around your filth.|r"
        end
    elseif type == "Bladder" then
        if value > 75 then return "|cff00FF00You feel comfortable.|r"
        elseif value > 50 then return "|cffFFFF00You could use a trip to the privy."
        elseif value > 25 then return "|cffFFD700Your bladder feels uncomfortably full.|r"
        elseif value > 10 then return "|cffFF8000You desperately need relief.|r"
        else return "|cffFF0000You're about to have an accident!|r"
        end
    end
end

-- Update UI
function addonTable.UpdateUI()
    if not addonTable.charData or not addonTable.charData.config then return end

    addonTable.ApplyUISettings()

    local indepth = addonTable.indepthMode
    local stats = {
        {name = "Hunger", value = addonTable.Hunger, enabled = addonTable.charData.config.hungerEnabled},
        {name = "Thirst", value = addonTable.Thirst, enabled = addonTable.charData.config.thirstEnabled},
        {name = "Fatigue", value = addonTable.Fatigue, enabled = addonTable.charData.config.fatigueEnabled},
        {name = "Hygiene", value = addonTable.Hygiene, enabled = addonTable.charData.config.hygieneEnabled},
        {name = "Bladder", value = addonTable.Bladder, enabled = addonTable.charData.config.bladderEnabled}
    }

    for i, data in ipairs(stats) do
        local row = addonTable.rows[i]
        if data.enabled then
            local icon = GetSeverityIcon(data.value)
            local status = addonTable.GetStatusText(data.value, data.name)
            if indepth then
                row.value:SetText(string.format("%s [%d%%] %s", icon, data.value, status))
            else
                row.value:SetText(string.format("%s %s", icon, status))
            end
        else
            row.value:SetText("")
        end
    end
end
