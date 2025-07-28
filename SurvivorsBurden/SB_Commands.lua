local addonName, addonTable = ...

local function SendImmersiveMessage(action)
    if not addonTable.charData.config.alertsEnabled then return end

    if addonTable.charData.config.broadcastAlerts then

        local msgs = addonTable.TextData.ImmersiveActions[action].emote
        if msgs then
            local msg = msgs[math.random(#msgs)]
            SendChatMessage(msg, "EMOTE")
        end
    else

        local msgs = addonTable.TextData.ImmersiveActions[action].print
        if msgs then
            print(msgs[math.random(#msgs)])
        end
    end
end

-- Help Commands
local function ShowHelp()
    print("|cffFFD700Survivor's Burden Commands:|r")
    print("|cFFFFFF00/sb on|off|r   - Enable or disable the system")
    print("|cFFFFFF00/sb status|r   - Show your current stats")
    print("|cFFFFFF00/sb eat <amount>|r - Restore Hunger")
    print("|cFFFFFF00/sb drink <amount>|r   - Restore Thirst")
    print("|cFFFFFF00/sb sleep <amount>|r   - Restore Fatigue")
    print("|cFFFFFF00/sb wash <amount>|r    - Restore Hygiene")
    print("|cFFFFFF00/sb relieve <amount>|r  - Restores Bladder (If enabled)")
end

-- Slash Commands
SLASH_SURVIVALSBURDEN1 = "/sb"
SlashCmdList["SURVIVALSBURDEN"] = function(msg)
    local args = {}
    for word in msg:gmatch("%S+") do table.insert(args, word) end
    local command = args[1] and args[1]:lower()
    local value = tonumber(args[2]) or 0

    if not command then
        if Settings and Settings.OpenToCategory then
            Settings.OpenToCategory("Survivor's Burden")
        elseif InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory("Survivor's Burden")
            InterfaceOptionsFrame_OpenToCategory("Survivor's Burden") -- Blizzard Fix Pls
        end
        return
    end

    if command == "help" then
        ShowHelp()
        return
    end

    if command == "on" or command == "off" or command == "toggle" then
        local enableState = addonTable.enabled

        if command == "toggle" then
            enableState = not enableState
        elseif command == "on" then
            enableState = true
        elseif command == "off" then
            enableState = false
        end

        addonTable.enabled = enableState
        addonTable.charData.enabled = enableState

        if enableState then
            addonTable.frame:Show()
        else
            addonTable.frame:Hide()
        end

        addonTable.SaveData()
        addonTable.UpdateUI()
        return
    end

    if command == "status" then
        print(string.format("Hunger: %d%% - %s", addonTable.Hunger, addonTable.GetStatusText(addonTable.Hunger, "Hunger")))
        print(string.format("Thirst: %d%% - %s", addonTable.Thirst, addonTable.GetStatusText(addonTable.Thirst, "Thirst")))
        print(string.format("Fatigue: %d%% - %s", addonTable.Fatigue, addonTable.GetStatusText(addonTable.Fatigue, "Fatigue")))
        print(string.format("Hygiene: %d%% - %s", addonTable.Hygiene, addonTable.GetStatusText(addonTable.Hygiene, "Hygiene")))
        if addonTable.charData.config.bladderEnabled then
            print(string.format("Bladder: %d%% - %s", addonTable.Bladder, addonTable.GetStatusText(addonTable.Bladder, "Bladder")))
        end
    end

    if command == "eat" then
        addonTable.Hunger = math.min(100, addonTable.Hunger + value)
        addonTable.ResetStage("Hunger", addonTable.Hunger)

        if addonTable.charData.config.bladderEnabled then
            addonTable.Bladder = math.max(0, addonTable.Bladder - math.floor(value / 2))
            addonTable.ResetStage("Bladder", addonTable.Bladder)
        end

        SendImmersiveMessage("eat")
        addonTable.SaveData()
        addonTable.UpdateUI()

        if addonTable.charData.config.soundsEnabled then
            PlaySound(266615, "Dialog")
        end
        return
    end

    if command == "drink" then
        addonTable.Thirst = math.min(100, addonTable.Thirst + value)
        addonTable.ResetStage("Thirst", addonTable.Thirst)

        if addonTable.charData.config.bladderEnabled then
            addonTable.Bladder = math.max(0, addonTable.Bladder - math.floor(value / 2))
            addonTable.ResetStage("Bladder", addonTable.Bladder)
        end
        
        SendImmersiveMessage("drink")
        addonTable.SaveData()
        addonTable.UpdateUI()

        if addonTable.charData.config.soundsEnabled then
            PlaySound(27087, "Dialog")
        end
        return
    end

    if command == "wash" then
        addonTable.Hygiene = math.min(100, addonTable.Hygiene + value)
        addonTable.ResetStage("Hygiene", addonTable.Hygiene)
        SendImmersiveMessage("wash")
        addonTable.SaveData()
        addonTable.UpdateUI()

        if addonTable.charData.config.soundsEnabled then
            PlaySound(176790, "Dialog")
        end
        return
    end

    if command == "sleep" then
        addonTable.Fatigue = math.min(100, addonTable.Fatigue + value)
        addonTable.ResetStage("Fatigue", addonTable.Fatigue)
        SendImmersiveMessage("sleep")
        addonTable.SaveData()
        addonTable.UpdateUI()

        if addonTable.charData.config.soundsEnabled then
            PlaySound(148212, "Dialog")
        end
        return
    end

    if command == "relieve" then
        addonTable.Bladder = math.min(100, addonTable.Bladder + value)
        addonTable.ResetStage("Bladder", addonTable.Bladder)
        SendImmersiveMessage("relieve")
        addonTable.SaveData()
        addonTable.UpdateUI()

        if addonTable.charData.config.soundsEnabled then
            PlaySound(278427, "Dialog")
        end
        return
    end

    if command == "indepth" then
        addonTable.indepthMode = not addonTable.indepthMode
        addonTable.SaveData()
        addonTable.UpdateUI()
        addonTable.ApplyUISettings()
        return
    end

    if command == "set" then
        local stat = args[2] and args[2]:lower()
        local amount = tonumber(args[3]) or 0
    if not stat or (stat ~= "hunger" and stat ~= "thirst" and stat ~= "fatigue" and stat ~= "hygiene" and stat ~= "bladder") then
        print("|cFFFFFF00Usage: /sb set <hunger|thirst|fatigue|hygiene|bladder> <amount>|r")
    else
        amount = math.max(0, math.min(100, amount))
        if stat == "hunger" then
            addonTable.Hunger = amount
            print(string.format("|cffFFD700[SB Debug]|r Hunger set to |cFFFFFF00%d%%|r.", addonTable.Hunger))
            addonTable.ResetStage("Hunger", addonTable.Hunger)
        elseif stat == "thirst" then
            addonTable.Thirst = amount
            print(string.format("|cffFFD700[SB Debug]|r Thirst set to |cFFFFFF00%d%%|r.", addonTable.Thirst))
            addonTable.ResetStage("Thirst", addonTable.Thirst)
        elseif stat == "fatigue" then
            addonTable.Fatigue = amount
            print(string.format("|cffFFD700[SB Debug]|r Fatigue set to |cFFFFFF00%d%%|r.", addonTable.Fatigue))
            addonTable.ResetStage("Fatigue", addonTable.Fatigue)
        elseif stat == "hygiene" then
            addonTable.Hygiene = amount
            print(string.format("|cffFFD700[SB Debug]|r Hygiene set to |cFFFFFF00%d%%|r.", addonTable.Hygiene))
            addonTable.ResetStage("Hygiene", addonTable.Hygiene)
        elseif stat == "bladder" then
            addonTable.Bladder = amount
            print(string.format("|cffFFD700[SB Debug]|r Bladder set to |cFFFFFF00%d%%|r.", addonTable.Bladder))
            addonTable.ResetStage("Bladder", addonTable.Bladder)
        end
        addonTable.SaveData()
        addonTable.UpdateUI()
        end
        return
    end

    if command == "alerts" then
        if args[2] == "on" then
            addonTable.charData.config.alertsEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.alertsEnabled = false
            addonTable.charData.config.broadcastAlerts = false
        else
            print("|cFFFFFF00Usage: /sb alerts on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "sounds" then
        if args[2] == "on" then
            addonTable.charData.config.soundsEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.soundsEnabled = false
        else
            print("|cFFFFFF00Usage: /sb sounds on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "movement" then
        if args[2] == "on" then
            addonTable.charData.config.movementDrainEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.movementDrainEnabled = false
        else
            print("|cFFFFFF00Usage: /sb movement on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "base" then
        if args[2] == "on" then
            addonTable.charData.config.baseDrainEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.baseDrainEnabled = false
        else
            print("|cFFFFFF00Usage: /sb base on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "emote" then
        if args[2] == "on" then
            addonTable.charData.config.emoteDrainEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.emoteDrainEnabled = false
        else
            print("|cFFFFFF00Usage: /sb emote on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "debug" then
        print("|cffFFD700[SB Debug]|r Triggering all alerts now...")
        addonTable.Hunger = 10
        addonTable.Thirst = 10
        addonTable.Fatigue = 10
        addonTable.Hygiene = 10
        addonTable.Bladder = 10
        addonTable.SaveData()
        addonTable.UpdateUI()
        if addonTable.charData.config.alertsEnabled then addonTable.CheckAlerts() end
        return
    end

    if command == "reset" then
        addonTable.Hunger, addonTable.Thirst, addonTable.Fatigue, addonTable.Hygiene, addonTable.Bladder = 100, 100, 100, 100, 100
        print("|cffFFD700[SB Debug]|r All needs restored to full.")
        addonTable.SaveData()
        addonTable.UpdateUI()
        addonTable.ResetStage("Hunger", addonTable.Hunger)
        addonTable.ResetStage("Thirst", addonTable.Thirst)
        addonTable.ResetStage("Fatigue", addonTable.Fatigue)
        addonTable.ResetStage("Hygiene", addonTable.Hygiene)
        addonTable.ResetStage("Bladder", addonTable.Bladder)
        if addonTable.charData then
            addonTable.charData.Hunger = 100
            addonTable.charData.Thirst = 100
            addonTable.charData.Fatigue = 100
            addonTable.charData.Hygiene = 100
            addonTable.charData.Bladder = 100
        end
        return
    end

    if command == "config" or command == "settings" then
        if Settings and Settings.OpenToCategory then
            -- Modern API (Retail)
            Settings.OpenToCategory("Survivor's Burden")
        elseif InterfaceOptionsFrame_OpenToCategory then
            -- Pre-Dragonflight
            InterfaceOptionsFrame_OpenToCategory("Survivor's Burden")
            InterfaceOptionsFrame_OpenToCategory("Survivor's Burden") -- BLIZZARD
        end
        return
    end

    if command == "minimap" then
        if args[2] == "on" then
            addonTable.charData.config.minimapEnabled = true
            addonTable.RegisterMinimapButton()
            LibStub("LibDBIcon-1.0"):Show("SurvivorsBurden")
        elseif args[2] == "off" then
            addonTable.charData.config.minimapEnabled = false
            LibStub("LibDBIcon-1.0"):Hide("SurvivorsBurden")
        else
            print("|cFFFFFF00Usage: /sb minimap on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "nomount" then
        if args[2] == "on" then
            addonTable.charData.config.noMountDrain = true
        elseif args[2] == "off" then
            addonTable.charData.config.noMountDrain = false
        else
            print("|cFFFFFF00Usage: /sb nomount on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "steps" then
        print("|cffFFD700[SB Debug]|r Steps Taken: |cffFFFF00" .. (addonTable.stepsTaken or 0) .. "|r")
        return
    end

    if command == "debugsteps" then
        addonTable.debugMove = not addonTable.debugMove
        print("|cffFFD700[SB Debug]|r Step Debug: |cffFFFF00" .. (addonTable.debugMove and "ON" or "OFF") .. "|r")
        return
    end

    if command == "hunger" or command == "thirst" or command == "fatigue" or command == "hygiene"  or command == "bladder" then
        local statKey = command .. "Enabled"
        if args[2] == "on" then
            addonTable.charData.config[statKey] = true
        elseif args[2] == "off" then
            addonTable.charData.config[statKey] = false
        else
            print("|cFFFFFF00Usage: /sb " .. command .. " on|off|r")
            return
        end

        addonTable.SaveData()
        addonTable.UpdateUI()
        addonTable.ApplyUISettings()
        return
    end

    if command == "armor" then
        if args[2] == "on" then
            addonTable.charData.config.armorDrainEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.armorDrainEnabled = false
        else
            print("|cFFFFFF00Usage: /sb armor on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "weapon" then
        if args[2] == "on" then
            addonTable.charData.config.weaponDrainEnabled = true
        elseif args[2] == "off" then
            addonTable.charData.config.weaponDrainEnabled = false
        else
            print("|cFFFFFF00Usage: /sb weapon on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "armorlist" then
        if addonTable.charData.config.armorDrainEnabled then
            local multiplier, armorCounts = addonTable.GetArmorWeightMultiplier()
            print("|cFFFFD700[SB Debug]|r Armor Weight Multiplier: |cffFFFF00" .. string.format("%.2f|r", multiplier))
            print(string.format("|cffFFD700[SB Debug]|r Plate: |cffFFFF00%d|r, Mail: |cffFFFF00%d|r, Leather: |cffFFFF00%d|r, Cloth: |cffFFFF00%d|r",
                armorCounts.Plate, armorCounts.Mail, armorCounts.Leather, armorCounts.Cloth))
        else
            print("|cffFFD700[SB Debug]|r Armor weight penalties are disabled.")
        end
        return
    end

    if command == "armoralert" then
        local multiplier, armorCounts = addonTable.GetArmorWeightMultiplier()
        addonTable.ShowArmorMessage(multiplier, armorCounts)
        return
    end

    if command == "armordrain" then
        addonTable.AdjustStats()
        print("|cFFFFD700[SB Debug] Forced stat drain applied with armor multiplier.|r")
        return
    end

    if command == "weaponlist" then
        if addonTable.charData.config.weaponDrainEnabled then
            local mult, weaponCounts = addonTable.GetWeaponWeightMultiplier()
            print("|cFFFFD700[SB Debug]|r Weapon Weight Multiplier: |cffFFFF00" .. string.format("%.2f|r", mult))
            print(string.format("|cffFFD700[SB Debug]|r Two-Handed: |cffFFFF00%d|r, One-Handed: |cffFFFF00%d|r, Shields: |cffFFFF00%d|r, Ranged: |cffFFFF00%d|r, Polearm: |cffFFFF00%d|r, Staff: |cffFFFF00%d|r",
                weaponCounts.TwoHanded or 0, weaponCounts.OneHanded or 0, weaponCounts.Shield or 0, weaponCounts.Bow or 0, weaponCounts.Polearm or 0, weaponCounts.Staff or 0))
        else
            print("|cffFFD700[SB Debug]|r Weapon weight penalties are disabled.")
        end
        return
    end

    if command == "total" then
        local totalMultiplier = 1.0
        local armorMultiplier, armorCounts = 1.0, {}
        local weaponMultiplier, weaponCounts = 0.0, {}

        if addonTable.charData.config.armorDrainEnabled then
            armorMultiplier, armorCounts = addonTable.GetArmorWeightMultiplier()
        else
            armorCounts = { Plate = 0, Mail = 0, Leather = 0, Cloth = 0 }
        end

        if addonTable.charData.config.weaponDrainEnabled then
            weaponMultiplier, weaponCounts = addonTable.GetWeaponWeightMultiplier()
        else
            weaponCounts = { TwoHanded = 0, OneHanded = 0, Shield = 0, Bow = 0, Polearm = 0, Staff = 0 }
        end

        totalMultiplier = armorMultiplier + weaponMultiplier - 1.0

        print("|cffFFD700[SB Debug]|r Total Weight Multiplier: |cffFFFF00" .. string.format("%.2f|r", totalMultiplier))
        print("|cffFFD700[SB Debug]|r Plate: |cffFFFF00" .. armorCounts.Plate .. "|r, Mail: |cffFFFF00" .. armorCounts.Mail ..
            "|r, Leather: |cffFFFF00" .. armorCounts.Leather .. "|r, Cloth: |cffFFFF00" .. armorCounts.Cloth .. "|r")
        print("|cffFFD700[SB Debug]|r 1H: |cffFFFF00" .. weaponCounts.OneHanded ..
            "|r, 2H: |cffFFFF00" .. weaponCounts.TwoHanded ..
            "|r, Shield: |cffFFFF00" .. weaponCounts.Shield ..
            "|r, Ranged: |cffFFFF00" .. weaponCounts.Bow .. "|r")
        return
    end

    if command == "broadcast" then
        if not addonTable.charData.config.alertsEnabled then
            print("|cffFFD700[SB Debug]|r Cannot enable broadcast without alerts enabled.")
            return
        end
        if args[2] == "on" then
            addonTable.charData.config.broadcastAlerts = true
        elseif args[2] == "off" then
            addonTable.charData.config.broadcastAlerts = false
        else
            print("|cFFFFFF00Usage: /sb broadcast on|off|r")
        end
        addonTable.SaveData()
        return
    end

    if command == "laststage" then
        print("|cffFFD700[SB Debug]|r Last Triggered Thresholds:")
        for stat, stage in pairs(addonTable.lastStage) do
            print(string.format(" - %s: %d", stat, stage))
        end
        return
    end

    ShowHelp()
end