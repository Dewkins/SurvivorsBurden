local addonName, addonTable = ...

SurvivorsBurden = LibStub("AceAddon-3.0"):NewAddon("SurvivorsBurden", "AceConsole-3.0", "AceEvent-3.0")
local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

local options = {
    name = "Survivor's Burden",
    type = "group",
    childGroups = "tab",
    args = {
        header = {
            type = "description",
            name = "" ..
                   "Track immersive survival needs for your RP character.\n" ..
                   "Maintain hunger, thirst, fatigue and hygiene while roleplaying.\n\n" ..
                   "|cFFAAAAAAAuthor:|r " .. addonTable.addonAuthor .. "   |cFFAAAAAAVersion:|r " .. addonTable.addonVersion .. "\n\n",
            order = 0,
            fontSize = "medium",
        },
        settings = {
            type = "group",
            name = "Settings",
            order = 1,
            args = {
                general = {
                    type = "group",
                    name = "General Settings",
                    inline = true,
                    order = 1,
                    args ={
                        enable = {
                            type = "toggle",
                            name = "Enable Addon",
                            desc = "Enable or disable Survivor's Burden.",
                            get = function() return addonTable.enabled end,
                            set = function(_, val)
                                addonTable.enabled = val
                                addonTable.charData.enabled = val
                                addonTable.SaveData()
                                if val then addonTable.frame:Show() else addonTable.frame:Hide() end
                            end,
                            order = 1,
                        },
                        indepth = {
                            type = "toggle",
                            name = "Show Percentages",
                            desc = "Show exact percentages in the UI.",
                            get = function() return addonTable.indepthMode end,
                            set = function(_, val)
                                addonTable.indepthMode = val
                                addonTable.charData.indepth = val
                                addonTable.SaveData()
                                addonTable.UpdateUI()
                                addonTable.ApplyUISettings()
                            end,
                            order = 2,
                        },
                        minimap = {
                            type = "toggle",
                            name = "Show Minimap Button",
                            desc = "Show or hide the minimap button.",
                            get = function() return addonTable.charData.config.minimapEnabled end,
                            set = function(_, val)
                                addonTable.charData.config.minimapEnabled = val
                                if val then
                                    addonTable.RegisterMinimapButton()
                                    LibStub("LibDBIcon-1.0"):Show("SurvivorsBurden")
                                else
                                    LibStub("LibDBIcon-1.0"):Hide("SurvivorsBurden")
                                end
                                addonTable.SaveData()
                            end,
                            order = 3,
                        },
                        uiScale = {
                            type = "range",
                            name = "UI Size",
                            desc = "Adjust the overall size of the UI.",
                            min = 0.5, max = 2.0, step = 0.05,
                            get = function() return addonTable.uiScale end,
                            set = function(_, val)
                                addonTable.uiScale = val
                                addonTable.charData.uiScale = val
                                addonTable.SaveData()
                                addonTable.ApplyUISettings()
                            end,
                            order = 4,
                        },
                    },
                },
            features = {
                type = "group",
                name = "Gameplay Options",
                inline = true,
                order = 2,
                args = {
                    sounds = {
                        type = "toggle",
                        name = "Notification Sounds",
                        desc = "Play sound effects for alerts.",
                        get = function() return addonTable.charData.config.soundsEnabled end,
                        set = function(_, val) addonTable.charData.config.soundsEnabled = val end,
                        order = 1,
                    },
                    alerts = {
                        type = "toggle",
                        name = "Notification Texts",
                        desc = "Show immersive chat alerts when stats drop.",
                        get = function() return addonTable.charData.config.alertsEnabled end,
                        set = function(_, val) addonTable.charData.config.alertsEnabled = val end,
                        order = 2,
                    },
                    broadcastAlerts = {
                        type = "toggle",
                        name = "Notification Broadcast",
                        desc = "Send immersive alerts as /me emotes to nearby players.",
                        get = function() return addonTable.charData.config.broadcastAlerts end,
                        set = function(_, val) addonTable.charData.config.broadcastAlerts = val end,
                        disabled = function() return not addonTable.charData.config.alertsEnabled end,
                        order = 3,
                    },
                },
            },
            drainage = {
                type = "group",
                name = "Decay Options",
                inline = true,
                order = 3,
                args = {
                    base = {
                        type = "toggle",
                        name = "Base Decay",
                        desc = "Stats decrease over time.",
                        get = function() return addonTable.charData.config.baseDrainEnabled end,
                        set = function(_, val) addonTable.charData.config.baseDrainEnabled = val end,
                        order = 1,
                    },
                    emote = {
                        type = "toggle",
                        name = "Emote Decay",
                        desc = "Stats decrease after RP emotes.",
                        get = function() return addonTable.charData.config.emoteDrainEnabled end,
                        set = function(_, val) addonTable.charData.config.emoteDrainEnabled = val end,
                        order = 2,
                    },
                    movement = {
                        type = "toggle",
                        name = "Travel Decay",
                        desc = "Stats decrease when you move long distances.",
                        get = function() return addonTable.charData.config.movementDrainEnabled end,
                        set = function(_, val) addonTable.charData.config.movementDrainEnabled = val end,
                        order = 3,
                    },
                    noMountDrain = {
                        type = "toggle",
                        name = "Suspend on Mounts",
                        desc = "Stops movement-based decay while mounted, flying or on a taxi.",
                        get = function() return addonTable.charData.config.noMountDrain end,
                        set = function(_, val) addonTable.charData.config.noMountDrain = val end,
                        order = 4,
                    },
                    armorDrain = {
                        type = "toggle",
                        name = "Armor Penalty",
                        desc = "Wearing heavy armor causes needs to drain faster.",
                        get = function() return addonTable.charData.config.armorDrainEnabled end,
                        set = function(_, val) addonTable.charData.config.armorDrainEnabled = val end,
                        order = 5,
                    },
                    weaponWeight = {
                        type = "toggle",
                        name = "Weapon Penalty",
                        desc = "Weapons increase needs decay rate depending on their weight.",
                        get = function() return addonTable.charData.config.weaponDrainEnabled end,
                        set = function(_, val) addonTable.charData.config.weaponDrainEnabled = val end,
                        order = 6,
                    },
                },
            },
            actions = {
                type = "group",
                name = "Debug Actions",
                inline = true,
                order = 5,
                args = {
                    reset = {
                        type = "execute",
                        name = "Reset All Needs",
                        desc = "Restore Hunger, Thirst, Fatigue and Hygiene to full.",
                        func = function()
                            addonTable.Hunger = 200
                            addonTable.Thirst = 200
                            addonTable.Fatigue = 200
                            addonTable.Hygiene = 200
                            addonTable.Bladder = 200
                            addonTable.charData.Hunger = 200
                            addonTable.charData.Thirst = 200
                            addonTable.charData.Fatigue = 200
                            addonTable.charData.Hygiene = 200
                            addonTable.charData.Bladder = 200
                            addonTable.ResetStage("Hunger", addonTable.Hunger)
                            addonTable.ResetStage("Thirst", addonTable.Thirst)
                            addonTable.ResetStage("Fatigue", addonTable.Fatigue)
                            addonTable.ResetStage("Hygiene", addonTable.Hygiene)
                            addonTable.ResetStage("Bladder", addonTable.Bladder)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            print(string.format("|cffFFD700[SB Debug]|r All needs restored to full."))
                        end,
                        order = 1,
                    },
                    armorlist = {
                        type = "execute",
                        name = "Show Equipment",
                        desc = "Lists equipment counts and current multiplier.",
                        func = function()
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
                        end,
                        order = 2,
                    },
                    debugsteps = {
                        type = "toggle",
                        name = "Toggle Step Debug",
                        desc = "Prints debug info for each step detected.",
                        get = function() return addonTable.debugMove or false end,
                        set = function(_, val)
                            addonTable.debugMove = val
                            print("|cffFFD700[SB Debug]|r Step Debug: |cffFFFF00" .. (addonTable.debugMove and "ON" or "OFF") .. "|r")
                            addonTable.UpdateUI()

                        end,
                        order = 3,
                    },
                },
            },
        },
    },
    needs = {
        type = "group",
        name = "Survival Needs",
        order = 2,
        args = {
            hungerSettings = {
                type = "group",
                name = "Hunger Settings",
                inline = true,
                order = 1,
                args = {
                    hungerEnabled = {
                        type = "toggle",
                        name = "Enable Hunger",
                        desc = "Enable or disable Hunger tracking.",
                        get = function() return addonTable.charData and addonTable.charData.config.hungerEnabled or false end,
                        set = function(_, val) addonTable.charData.config.hungerEnabled = val 
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            addonTable.ApplyUISettings()
                        end,
                        order = 1,
                    },
                    hunger = {
                        type = "range",
                        name = "Set Hunger",
                        desc = "Adjust your Hunger stat.",
                        min = 0, max = 200, step = 1,
                        get = function() return addonTable.Hunger or 0 end,
                        set = function(_, val)
                            addonTable.Hunger = val
                            addonTable.charData.Hunger = val
                            addonTable.ResetStage("Hunger", addonTable.Hunger)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                        end,
                        order = 2,
                    },
                },
            },
            thirstSettings = {
                type = "group",
                name = "Thirst Settings",
                inline = true,
                order = 2,
                args = {
                    thirstEnabled = {
                        type = "toggle",
                        name = "Enable Thirst",
                        desc = "Enable or disable Thirst tracking.",
                        get = function() return addonTable.charData and addonTable.charData.config.thirstEnabled or false end,
                        set = function(_, val) addonTable.charData.config.thirstEnabled = val 
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            addonTable.ApplyUISettings()
                        end,
                        order = 1,
                    },
                    thirst = {
                        type = "range",
                        name = "Set Thirst",
                        desc = "Adjust your Thirst stat.",
                        min = 0, max = 200, step = 1,
                        get = function() return addonTable.Thirst or 0 end,
                        set = function(_, val)
                            addonTable.Thirst = val
                            addonTable.charData.Thirst = val
                            addonTable.ResetStage("Thirst", addonTable.Thirst)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                        end,
                        order = 2,
                    },
                },
            },
            fatigueSettings = {
                type = "group",
                name = "Fatigue Settings",
                inline = true,
                order = 3,
                args = {
                    fatigueEnabled = {
                        type = "toggle",
                        name = "Enable Fatigue",
                        desc = "Enable or disable Fatigue tracking.",
                        get = function() return addonTable.charData and addonTable.charData.config.fatigueEnabled or false end,
                        set = function(_, val) addonTable.charData.config.fatigueEnabled = val 
                            addonTable.ResetStage("Fatigue", addonTable.Fatigue)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            addonTable.ApplyUISettings()
                        end,
                        order = 1,
                    },
                    fatigue = {
                        type = "range",
                        name = "Set Fatigue",
                        desc = "Adjust your Fatigue stat.",
                        min = 0, max = 200, step = 1,
                        get = function() return addonTable.Fatigue or 0 end,
                        set = function(_, val)
                            addonTable.Fatigue = val
                            addonTable.charData.Fatigue = val
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                        end,
                        order = 2,
                    },
                },
            },
            hygieneSettings = {
                type = "group",
                name = "Hygiene Settings",
                inline = true,
                order = 4,
                args = {
                    hygieneEnabled = {
                        type = "toggle",
                        name = "Enable Hygiene",
                        desc = "Enable or disable Hygiene tracking.",
                        get = function() return addonTable.charData and addonTable.charData.config.hygieneEnabled or false end,
                        set = function(_, val) addonTable.charData.config.hygieneEnabled = val 
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            addonTable.ApplyUISettings()
                        end,
                        order = 1,
                    },
                    hygiene = {
                        type = "range",
                        name = "Set Hygiene",
                        desc = "Adjust your Hygiene stat.",
                        min = 0, max = 200, step = 1,
                        get = function() return addonTable.Hygiene or 0 end,
                        set = function(_, val)
                            addonTable.Hygiene = val
                            addonTable.charData.Hygiene = val
                            addonTable.ResetStage("Hygiene", addonTable.Hygiene)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                        end,
                        order = 2,
                    },
                },
            },
            bladderSettings = {
                type = "group",
                name = "Bladder Settings",
                inline = true,
                order = 5,
                args = {
                    bladderEnabled = {
                        type = "toggle",
                        name = "Enable Bladder",
                        desc = "Enable or disable Bladder tracking.",
                        get = function() return addonTable.charData and addonTable.charData.config.bladderEnabled or false end,
                        set = function(_, val)
                            addonTable.charData.config.bladderEnabled = val
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                            addonTable.ApplyUISettings()
                        end,
                        order = 1,
                    },
                    bladder = {
                        type = "range",
                        name = "Set Bladder",
                        desc = "Adjust your Bladder stat.",
                        min = 0, max = 200, step = 1,
                        get = function() return addonTable.Bladder or 0 end,
                        set = function(_, val)
                            addonTable.Bladder = val
                            addonTable.charData.Bladder = val
                            addonTable.ResetStage("Bladder", addonTable.Bladder)
                            addonTable.SaveData()
                            addonTable.UpdateUI()
                        end,
                        order = 2,
                    },
                },
            },
        },
    },
    },
}

if not addonTable.charData then
    addonTable.LoadData()
end

function SurvivorsBurden:OnInitialize()
    AC:RegisterOptionsTable("SurvivorsBurdenGeneral", options)
    ACD:AddToBlizOptions("SurvivorsBurdenGeneral", "Survivor's Burden")
end