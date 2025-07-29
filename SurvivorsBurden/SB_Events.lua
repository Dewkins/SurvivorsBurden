local addonName, addonTable = ...

local frame = addonTable.frame
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("CHAT_MSG_SAY")
frame:RegisterEvent("CHAT_MSG_EMOTE")

frame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == addonName then
        addonTable.LoadData()
        addonTable.SaveData()

        if addonTable.charData.config.minimapEnabled then
            addonTable.RegisterMinimapButton()
        end

        addonTable.ApplyUISettings()
        addonTable.UpdateUI()
        
        print("|cffFFD700Survivor's Burden|r |cffFF8000" .. addonTable.addonVersion .. "|r Loaded. Type |cffffff00/sb help|r for commands.")
        if addonTable.enabled then frame:Show() else frame:Hide() end

    elseif event == "PLAYER_LOGOUT" then
        addonTable.SaveData()

    elseif addonTable.enabled and (event == "CHAT_MSG_SAY" or event == "CHAT_MSG_EMOTE") then
        if arg2 == UnitName("player") .. "-" .. GetRealmName() then return end

        if addonTable.charData.config.emoteDrainEnabled then
            addonTable.emoteCounter = addonTable.emoteCounter + 1
            if addonTable.emoteCounter >= 5 then
                if addonTable.charData.config.hungerEnabled then
                    addonTable.Hunger = math.max(0, addonTable.Hunger - 0.5)
                end
                if addonTable.charData.config.thirstEnabled then
                    addonTable.Thirst = math.max(0, addonTable.Thirst - 1)
                end

                if math.random(1, 100) <= 75 then
                    if addonTable.charData.config.fatigueEnabled then
                        addonTable.Fatigue = math.max(0, addonTable.Fatigue - 0.5)
                    end
                end

                addonTable.emoteCounter = 0
                addonTable.SaveData()
                addonTable.UpdateUI()
                addonTable.CheckAlerts()
            end
        end
    end
end)

frame:SetScript("OnUpdate", function(self, delta)
    if not addonTable.enabled then return end
    addonTable.elapsed = addonTable.elapsed + delta
    if addonTable.elapsed >= 5 then
        addonTable.CheckMovement()
    end
    if addonTable.elapsed >= addonTable.baseTickInterval and addonTable.charData.config.baseDrainEnabled then
        addonTable.AdjustStats()
        addonTable.elapsed = 0
    end
end)
