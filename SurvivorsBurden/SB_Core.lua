local addonName, addonTable = ...

-- Version Info
addonTable.addonName = addonName
addonTable.addonAuthor = "Dewkins"
addonTable.addonVersion = "v1.1"

-- Saved Variables
SurvivorsBurdenDB = SurvivorsBurdenDB or {}
local playerKey = UnitName("player") .. "-" .. GetRealmName()

-- Default Values
addonTable.Hunger = 200
addonTable.Thirst = 200
addonTable.Fatigue = 200
addonTable.Hygiene = 200
addonTable.Bladder = 200
addonTable.enabled = true
addonTable.indepthMode = false

addonTable.stepsTaken = 0
addonTable.lastX, addonTable.lastY = nil, nil
addonTable.stepThreshold = 0.7 -- approx. 0.7 yards per step

addonTable.baseTickInterval = 600 -- 10 min
addonTable.elapsed = 0
addonTable.moveDrainCounter = 0
addonTable.emoteCounter = 0
addonTable.lastX, addonTable.lastY = nil, nil

addonTable.lastStage = addonTable.lastStage or {
    Hunger = 200, Thirst = 200, Fatigue = 200, Hygiene = 200, Bladder = 200,
}

-- Default Config
function addonTable.GetDefaultConfig()
    return {
        Hunger = 200, Thirst = 200, Fatigue = 200, Hygiene = 200, Bladder = 200,
        enabled = true,
        indepth = false,
        config = {
            hungerEnabled = true,
            thirstEnabled = true,
            fatigueEnabled = true,
            hygieneEnabled = true,
            bladderEnabled = false,
            alertsEnabled = true,
            soundsEnabled = true,
            movementDrainEnabled = true,
            baseDrainEnabled = true,
            emoteDrainEnabled = true,
            minimapEnabled = true,
            noMountDrain = true,
            armorDrainEnabled = true,
            weaponDrainEnabled = true,
            broadcastAlerts = false
        }
    }
end

-- Load Data
function addonTable.LoadData()
    if not SurvivorsBurdenDB[playerKey] then
        SurvivorsBurdenDB[playerKey] = addonTable.GetDefaultConfig()
    end
    addonTable.charData = SurvivorsBurdenDB[playerKey]
    
    addonTable.Hunger = addonTable.charData.Hunger or 200
    addonTable.Thirst = addonTable.charData.Thirst or 200
    addonTable.Fatigue = addonTable.charData.Fatigue or 200
    addonTable.Hygiene = addonTable.charData.Hygiene or 200
    addonTable.Bladder = addonTable.charData.Bladder or 200

    addonTable.enabled = addonTable.charData.enabled
    addonTable.indepthMode = addonTable.charData.indepth
    
    addonTable.uiScale = addonTable.charData.uiScale or 1.0
    
    addonTable.InitializeLastStages()
end

-- Save Data
function addonTable.SaveData()
    if not addonTable.charData then return end

    addonTable.charData.Hunger = addonTable.Hunger
    addonTable.charData.Thirst = addonTable.Thirst
    addonTable.charData.Fatigue = addonTable.Fatigue
    addonTable.charData.Hygiene = addonTable.Hygiene
    addonTable.charData.Bladder = addonTable.Bladder
    addonTable.charData.enabled = addonTable.enabled
    addonTable.charData.indepth = addonTable.indepthMode
    addonTable.charData.uiScale = addonTable.uiScale
end
