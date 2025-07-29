local addonName, addonTable = ...

-- Initialize Stages
function addonTable.InitializeLastStages()
    addonTable.lastStage = addonTable.lastStage or {}

    local function determineStage(value)
        if value > 100 then return 200
        elseif value > 75 then return 100
        elseif value > 50 then return 75
        elseif value > 25 then return 50
        elseif value > 10 then return 25
        else return 10
        end
    end

    if addonTable.charData.config.hungerEnabled then
        addonTable.lastStage["Hunger"] = determineStage(addonTable.Hunger)
    end
    if addonTable.charData.config.thirstEnabled then
        addonTable.lastStage["Thirst"] = determineStage(addonTable.Thirst)
    end
    if addonTable.charData.config.fatigueEnabled then
        addonTable.lastStage["Fatigue"] = determineStage(addonTable.Fatigue)
    end
    if addonTable.charData.config.hygieneEnabled then
        addonTable.lastStage["Hygiene"] = determineStage(addonTable.Hygiene)
    end
    if addonTable.charData.config.bladderEnabled then
        addonTable.lastStage["Bladder"] = determineStage(addonTable.Bladder)
    end
end


-- Reset Stage
function addonTable.ResetStage(stat, value)
    if value > 100 then
        addonTable.lastStage[stat] = 200
    elseif value > 75 then
        addonTable.lastStage[stat] = 100
    elseif value > 50 then
        addonTable.lastStage[stat] = 75
    elseif value > 25 then
        addonTable.lastStage[stat] = 50
    elseif value > 10 then
        addonTable.lastStage[stat] = 25
    else
        addonTable.lastStage[stat] = 10
    end
    addonTable.SaveData()
end

-- Play Sounds
function addonTable.PlayAlertSound(stat, threshold)
    if not addonTable.charData.config.soundsEnabled then return end

    if stat == "Hunger" then
        local handle = PlaySoundFile(addonTable.alertSounds.Hunger, "Dialog")

    elseif stat == "Thirst" then
        local raceID = select(3, UnitRace("player"))
        local genderID = UnitSex("player")
        local soundData = addonTable.alertSounds.Thirst[raceID]
        if soundData then
            local genderKey = (genderID == 2) and "Male" or "Female"
            local soundID = soundData[genderKey]
            if soundID then PlaySound(soundID, "Dialog") end
        end

    elseif stat == "Fatigue" then
        local raceID = select(3, UnitRace("player"))
        local genderID = UnitSex("player")
        local soundData = addonTable.alertSounds.Fatigue[raceID]
        if soundData then
            local genderKey = (genderID == 2) and "Male" or "Female"
            local soundID = soundData[genderKey]
            if soundID then PlaySound(soundID, "Dialog") end
        end

    elseif stat == "Hygiene" then
        local handle
        if threshold == 50 then
            handle = PlaySoundFile(addonTable.alertSounds.Hygiene.sniff, "Dialog")
        else
            handle = PlaySoundFile(addonTable.alertSounds.Hygiene.buzz, "Dialog")
        end

    elseif stat == "Bladder" then
        local handle = PlaySound(26763, "Dialog")
    end
end

-- Check Alerts
local function getStageBucket(value)
    if value > 100 then return 200
    elseif value > 75 then return 100
    elseif value > 50 then return 75
    elseif value > 25 then return 50
    elseif value > 10 then return 25
    else return 10
    end
end

function addonTable.CheckAlerts()
    local function processAlert(stat, value)
        if value >= 100 then return end

        local previousBucket = addonTable.lastStage[stat] or 100
        local currentBucket = getStageBucket(value)

        if currentBucket < previousBucket then

            local index = (currentBucket == 50 and 1) or (currentBucket == 25 and 2) or (currentBucket == 10 and 3) or 1

            if addonTable.charData.config.alertsEnabled then
                if addonTable.charData.config.broadcastAlerts then
                    SendChatMessage(addonTable.TextData.Alerts[stat].emote[index], "EMOTE")
                else
                    print("|cFFFF9900" .. addonTable.TextData.Alerts[stat].print[index] .. "|r")
                end
            end

            addonTable.PlayAlertSound(stat, currentBucket)
        end

        addonTable.lastStage[stat] = currentBucket
    end

    if addonTable.charData.config.hungerEnabled then
        processAlert("Hunger", addonTable.Hunger)
    end
    if addonTable.charData.config.thirstEnabled then
        processAlert("Thirst", addonTable.Thirst)
    end
    if addonTable.charData.config.fatigueEnabled then
        processAlert("Fatigue", addonTable.Fatigue)
    end
    if addonTable.charData.config.hygieneEnabled then
        processAlert("Hygiene", addonTable.Hygiene)
    end
    if addonTable.charData.config.bladderEnabled then
        processAlert("Bladder", addonTable.Bladder)
    end
end


-- Armor Drain
function addonTable.GetArmorWeightMultiplier()
    local multiplier = 1.0
    local slots = {1, 3, 5, 10} -- Head, Shoulder, Chest, Hands
    local armorCounts = {Plate = 0, Mail = 0, Leather = 0, Cloth = 0}

    for _, slot in ipairs(slots) do
        local itemID = GetInventoryItemID("player", slot)
        if itemID then
            local _, _, _, _, _, itemType, itemSubType = GetItemInfo(itemID)
            if itemType == "Armor" and armorCounts[itemSubType] then
                armorCounts[itemSubType] = armorCounts[itemSubType] + 1
            end
        end
    end

    for armorType, count in pairs(armorCounts) do
        if armorType == "Plate" then multiplier = multiplier + (0.5 * count)
        elseif armorType == "Mail" then multiplier = multiplier + (0.3 * count)
        elseif armorType == "Leather" then multiplier = multiplier + (0.2 * count)
        elseif armorType == "Cloth" then multiplier = multiplier + (0.1 * count)
        end
    end

    return multiplier, armorCounts
end

-- Weapon Drain
function addonTable.GetWeaponWeightMultiplier()
    local multiplier = 0.0
    local weaponCounts = {OneHanded = 0, TwoHanded = 0, Shield = 0, Bow = 0}

    local function checkWeapon(slotID)
        if not slotID then return end
        local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(slotID)

        if classID == 2 then
            if subClassID == 0 or subClassID == 4 or subClassID == 7 then
                weaponCounts.OneHanded = weaponCounts.OneHanded + 1
                multiplier = multiplier + 0.5
            elseif subClassID == 1 or subClassID == 5 or subClassID == 8 then
                weaponCounts.TwoHanded = weaponCounts.TwoHanded + 1
                multiplier = multiplier + 0.7
            elseif subClassID == 6 then
                weaponCounts.TwoHanded = weaponCounts.TwoHanded + 1
                multiplier = multiplier + 0.8
            elseif subClassID == 15 then
                weaponCounts.OneHanded = weaponCounts.OneHanded + 1
                multiplier = multiplier + 0.2
            elseif subClassID == 10 then
                weaponCounts.TwoHanded = weaponCounts.TwoHanded + 1
                multiplier = multiplier + 0.7
            elseif subClassID == 2 or subClassID == 3 or subClassID == 18 then
                weaponCounts.Bow = weaponCounts.Bow + 1
                multiplier = multiplier + 1
            end
        elseif classID == 4 and subClassID == 6 then
            weaponCounts.Shield = weaponCounts.Shield + 1
            multiplier = multiplier + 1
        end
    end

    checkWeapon(GetInventoryItemID("player", 16))
    checkWeapon(GetInventoryItemID("player", 17))

    return multiplier, weaponCounts
end

-- Total Drain
function addonTable.GetTotalWeightMultiplier()
    local multiplier = 1.0
    local armorCounts, weaponCounts = {}, {}

    if addonTable.charData.config.armorDrainEnabled then
        local armorMult, aCounts = addonTable.GetArmorWeightMultiplier()
        multiplier = multiplier + (armorMult - 1.0)
        armorCounts = aCounts
    end

    if addonTable.charData.config.weaponDrainEnabled then
        local weaponMult, wCounts = addonTable.GetWeaponWeightMultiplier()
        multiplier = multiplier + weaponMult
        weaponCounts = wCounts
    end

    return multiplier, armorCounts, weaponCounts
end

-- Equipment Alerts
addonTable.lastArmorMsgTime = 0
function addonTable.ShowArmorMessage(multiplier, armorCounts, weaponCounts)
    if GetTime() - addonTable.lastArmorMsgTime < 1800 then return end
    addonTable.lastArmorMsgTime = GetTime()

    if addonTable.charData.config.soundsEnabled then
        PlaySound(270927, "Dialog")
    end

    if not addonTable.charData.config.alertsEnabled then return end

    local playerName = UnitName("player")
    local selectedMsg
    if armorCounts.Plate > 3 then selectedMsg = addonTable.TextData.GearMessages.plate
    elseif armorCounts.Mail > 3 then selectedMsg = addonTable.TextData.GearMessages.mail
    elseif armorCounts.Leather > 3 then selectedMsg = addonTable.TextData.GearMessages.leather
    else selectedMsg = addonTable.TextData.GearMessages.weapon end

    if addonTable.charData.config.broadcastAlerts then
        SendChatMessage(selectedMsg.emote:format(playerName), "EMOTE")
    else
        print("|cFFFF9900" .. selectedMsg.print .. "|r")
    end
end

-- Base Drain
function addonTable.AdjustStats()
    local multiplier, armorCounts, weaponCounts = addonTable.GetTotalWeightMultiplier()

    if addonTable.charData.config.hungerEnabled then
        addonTable.Hunger = math.max(0, addonTable.Hunger - (0.5 * multiplier))
    end
    if addonTable.charData.config.thirstEnabled then
        addonTable.Thirst = math.max(0, addonTable.Thirst - (1 * multiplier))
    end
    if addonTable.charData.config.fatigueEnabled then
        addonTable.Fatigue = math.max(0, addonTable.Fatigue - (0.3 * multiplier))
    end
    if addonTable.charData.config.hygieneEnabled then
        addonTable.Hygiene = math.max(0, addonTable.Hygiene - (1 * multiplier))
    end

    if addonTable.charData.config.bladderEnabled then
        addonTable.Bladder = math.max(0, addonTable.Bladder - (1 * multiplier))
    end

    if addonTable.Thirst < 25 then addonTable.Fatigue = math.max(0, addonTable.Fatigue - 2) end
    if addonTable.Fatigue < 25 then addonTable.Hunger = math.max(0, addonTable.Hunger - 1) end

    addonTable.ShowArmorMessage(multiplier, armorCounts, weaponCounts)
    addonTable.SaveData()
    addonTable.UpdateUI()
    addonTable.CheckAlerts()
end

-- Movement Drain
function addonTable.CheckMovement()
    if addonTable.charData.config.noMountDrain and (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) then
        return
    end

    local _, class = UnitClass("player")
    if class == "DRUID" then
        local form = GetShapeshiftFormID()
        if form == 31 or form == 27 then
            return
        end
    end

    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end

    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return end

    local x, y = pos.x, pos.y

    if addonTable.lastX and addonTable.lastY then
        local dx = (x - addonTable.lastX) * 1000
        local dy = (y - addonTable.lastY) * 1000
        local dist = math.sqrt(dx * dx + dy * dy)

        if dist >= 0.7 then
            addonTable.stepsTaken = (addonTable.stepsTaken or 0) + 1
            addonTable.lastX, addonTable.lastY = x, y

            if addonTable.debugMove then
                addonTable.UpdateUI()
            end

            if addonTable.stepsTaken % 200 == 0 and addonTable.charData.config.movementDrainEnabled then
                local multiplier = 1.0
                if addonTable.charData.config.armorDrainEnabled then
                    local armorMult = select(1, addonTable.GetArmorWeightMultiplier())
                    multiplier = multiplier + (armorMult - 1.0)
                end
                if addonTable.charData.config.weaponDrainEnabled then
                    local weaponMult = select(1, addonTable.GetWeaponWeightMultiplier())
                    multiplier = multiplier + weaponMult
                end

                if addonTable.charData.config.hungerEnabled then
                    addonTable.Hunger = math.max(0, addonTable.Hunger - (1 * multiplier))
                end
                if addonTable.charData.config.thirstEnabled then
                    addonTable.Thirst = math.max(0, addonTable.Thirst - (1 * multiplier))
                end
                if addonTable.charData.config.fatigueEnabled then
                    addonTable.Fatigue = math.max(0, addonTable.Fatigue - (0.8 * multiplier))
                end
                if addonTable.charData.config.hygieneEnabled then
                    addonTable.Hygiene = math.max(0, addonTable.Hygiene - (1 * multiplier))
                end

                if addonTable.charData.config.bladderEnabled then
                    addonTable.Bladder = math.max(0, addonTable.Bladder - (1 * multiplier))
                end

                addonTable.SaveData()
                addonTable.UpdateUI()
                addonTable.CheckAlerts()
            end
        end
    else
        addonTable.lastX, addonTable.lastY = x, y
    end
end