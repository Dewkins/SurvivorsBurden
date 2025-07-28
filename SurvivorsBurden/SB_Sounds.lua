local addonName, addonTable = ...

-- Sound ID Table
addonTable.alertSounds = {
    Hunger = "Interface\\AddOns\\SurvivorsBurden\\Sounds\\stomach_growl.ogg",
    Thirst = {
        -- ALLIANCE CORE RACES
        [1]  = { Male =  7914,   Female =  7894 }, -- Human
        [3]  = { Male =  7918,   Female =  7917 }, -- Dwarf
        [4]  = { Male =  7916,   Female =  7915 }, -- Night Elf
        [7]  = { Male =  7920,   Female =  7919 }, -- Gnome
        [11] = { Male = 10579,   Female = 10577 }, -- Draenei
        [22] = { Male =  7922,   Female =  26567 }, -- Worgen
        
        -- ALLIANCE ALLIED RACES
        [29] = { Male = 95681,   Female = 95886 }, -- Void Elf
        [30] = { Male = 96263,   Female = 96195 }, -- Lightforged Draenei
        [34] = { Male = 101972,  Female = 101898 }, -- Dark Iron Dwarf
        [32] = { Male = 127141,  Female = 127047 }, -- Kul Tiran
        [37] = { Male = 143902,  Female = 144285 }, -- Mechagnome
        
        -- HORDE CORE RACES
        [2]  = { Male =  7922,   Female =  7921 }, -- Orc
        [5]  = { Male =  7928,   Female =  7927 }, -- Undead
        [6]  = { Male =  7926,   Female =  7925 }, -- Tauren
        [8]  = { Male =  7924,   Female =  7923 }, -- Troll
        [9]  = { Male = 7918,   Female = 10577 }, -- Goblin
        [10] = { Male = 10575,   Female = 10573 }, -- Blood Elf
        
        -- HORDE ALLIED RACES
        [27] = { Male = 96399,   Female = 96331 }, -- Nightborne
        [28] = { Male = 95880,   Female = 95559 }, -- Highmountain Tauren
        [36] = { Male = 110409,  Female = 110334 }, -- Mag'har Orc
        [31] = { Male = 127328,  Female = 126954 }, -- Zandalari Troll
        [35] = { Male = 144121,  Female = 144029 }, -- Vulpera
        
        -- NEUTRAL
        [24] = { Male = 30048,   Female = 33971 }, -- Pandaren (Neutral)
        [25] = { Male = 30048,   Female = 33971 }, -- Pandaren (Alliance)
        [26] = { Male = 30048,   Female = 33971 }, -- Pandaren (Horde)
        
        -- DRAGONS & NEW RACES
        [52] = { Male = 212609,  Female = 212699 }, -- Dracthyr (Alliance)
        [70] = { Male = 212609,  Female = 212699 }, -- Dracthyr (Horde)
        [75] = { Male = 212513,  Female = 212788 }, -- Visage (Alliance)
        [76] = { Male = 212513,  Female = 212788 }, -- Visage (Horde)
        [84] = { Male = 262438,  Female = 262363 }, -- Earthen (Alliance)
        [85] = { Male = 262438,  Female = 262363 }, -- Earthen (Horde)
    },
    Fatigue = {
        -- ALLIANCE CORE RACES
        [1]  = { Male =  7932,   Female =  7931 }, -- Human
        [3]  = { Male =  7936,   Female =  7935 }, -- Dwarf
        [4]  = { Male =  7934,   Female =  7933 }, -- Night Elf
        [7]  = { Male =  7938,   Female =  7937 }, -- Gnome
        [11] = { Male = 10580,   Female = 10578 }, -- Draenei
        [22] = { Male =  7940,   Female =  7939 }, -- Worgen
        
        -- ALLIANCE ALLIED RACES
        [29] = { Male = 95673,   Female = 95872 }, -- Void Elf
        [30] = { Male = 96255,   Female = 96187 }, -- Lightforged Draenei
        [34] = { Male = 101980,  Female = 101906 }, -- Dark Iron Dwarf
        [32] = { Male = 127079,  Female = 126985 }, -- Kul Tiran
        [37] = { Male = 143840,  Female = 144261 }, -- Mechagnome
        
        -- HORDE CORE RACES
        [2]  = { Male =  7940,   Female =  7939 }, -- Orc
        [5]  = { Male =  7942,   Female =  7941 }, -- Undead
        [6]  = { Male =  7946,   Female =  7945 }, -- Tauren
        [8]  = { Male =  7944,   Female =  7943 }, -- Troll
        [9]  = { Male = 10576,   Female = 10578 }, -- Goblin
        [10] = { Male = 10576,   Female = 10574 }, -- Blood Elf
        
        -- HORDE ALLIED RACES
        [27] = { Male = 96391,   Female = 96323 }, -- Nightborne
        [28] = { Male = 95862,   Female = 95551 }, -- Highmountain Tauren
        [36] = { Male = 110347,  Female = 110272 }, -- Mag'har Orc
        [31] = { Male = 127266,  Female = 126892 }, -- Zandalari Troll
        [35] = { Male = 144097,  Female = 144005 }, -- Vulpera
        
        -- NEUTRAL
        [24] = { Male = 30049,   Female = 31725 }, -- Pandaren (Neutral)
        [25] = { Male = 30049,   Female = 31725 }, -- Pandaren (Alliance)
        [26] = { Male = 30049,   Female = 31725 }, -- Pandaren (Horde)
        
        -- DRAGONS & NEW RACES
        [52] = { Male = 212621,  Female = 212711 }, -- Dracthyr (Alliance)
        [70] = { Male = 212621,  Female = 212711 }, -- Dracthyr (Horde)
        [75] = { Male = 212523,  Female = 212800 }, -- Visage (Alliance)
        [76] = { Male = 212523,  Female = 212800 }, -- Visage (Horde)
        [84] = { Male = 262448,  Female = 262374 }, -- Earthen (Alliance)
        [85] = { Male = 262448,  Female = 262374 }, -- Earthen (Horde)
    },
    Hygiene = {
        sniff = "Interface\\AddOns\\SurvivorsBurden\\Sounds\\sniff.ogg",
        buzz = "Interface\\AddOns\\SurvivorsBurden\\Sounds\\fly_buzz.ogg"
    },
}