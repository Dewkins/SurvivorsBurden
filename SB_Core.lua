local addonName, addonTable = ...

-- Version Info
addonTable.addonName = addonName
addonTable.addonAuthor = "Dewkins"
addonTable.addonVersion = "v1.0"

-- Saved Variables
SurvivorsBurdenDB = SurvivorsBurdenDB or {}
local playerKey = UnitName("player") .. "-" .. GetRealmName()

-- Default Values
addonTable.Hunger = 100
addonTable.Thirst = 100
addonTable.Fatigue = 100
addonTable.Hygiene = 100
addonTable.Bladder = 100
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
    Hunger = 100, Thirst = 100, Fatigue = 100, Hygiene = 100, Bladder = 100
}

-- Default Config
function addonTable.GetDefaultConfig()
    return {
        Hunger = 100, Thirst = 100, Fatigue = 100, Hygiene = 100, Bladder = 100,
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
    
    addonTable.Hunger = addonTable.charData.Hunger or 100
    addonTable.Thirst = addonTable.charData.Thirst or 100
    addonTable.Fatigue = addonTable.charData.Fatigue or 100
    addonTable.Hygiene = addonTable.charData.Hygiene or 100
    addonTable.Bladder = addonTable.charData.Bladder or 100

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
