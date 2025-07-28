local addonName, addonTable = ...

addonTable.TextData = {
    Alerts = {
       Hunger = {
            print = {
                "Your stomach growls with hunger.",
                "You feel light-headed with hunger.",
                "You're starving. Your body aches for food."
            },
            emote = {
                "clutches their stomach as hunger gnaws at them.",
                "sways on their feet, weakened by hunger.",
                "looks frail, starving for sustenance."
            }
        },
        Thirst = {
            print = {
                "You thirst for water.",
                "Your throat burns with thirst.",
                "Your lips crack and your head spins from dehydration."
            },
            emote = {
                "licks their parched lips, desperate for water.",
                "swallows dryly, throat burning with thirst.",
                "stumbles, dehydrated and dizzy."
            }
        },
        Fatigue = {
            print = {
                "You feel your body growing weary.",
                "Your eyelids fight to stay open.",
                "Your legs tremble under your own weight."
            },
            emote = {
                "slumps, exhaustion evident in their posture.",
                "fights to keep their eyes open, fatigue taking hold.",
                "staggers, barely able to stand."
            }
        },
        Hygiene = {
            print = {
                "Grime clings to your skin.",
                "You smell strongly of grime and sweat.",
                "Flies buzz around your filth."
            },
            emote = {
                "reeks of grime and sweat.",
                "carries the stench of days without washing.",
                "smells so foul that flies circle them."
            }
        },
        Bladder = {
            print = {
                "You feel the need to relieve yourself.",
                "Your bladder feels painfully full.",
                "You're about to burst!"
            },
            emote = {
                "shifts uncomfortably, looking for a privy.",
                "squirms, bladder clearly full.",
                "grimaces, desperate for relief."
            }
        }
    },
    GearMessages = {
        plate = {
            print = "The weight of your heavy plate drags on your limbs.",
            emote = "heavy plate drags on their limbs."
        },
        mail = {
            print = "The mail armor rattles as it slows your stride.",
            emote = "mail armor rattles as they move slowly."
        },
        leather = {
            print = "The snug leather makes every movement warmer.",
            emote = "snug leather clings tightly, heating every motion."
        },
        weapon = {
            print = "Your heavy weapon weighs down your stance.",
            emote = "heavy weapon drags their arms down."
        }
    },
    ImmersiveActions = {
        eat = {
            print = {
                "|cFFFF9900You take a hearty bite and feel your hunger fade.|r",
                "|cFFFF9900The food fills your stomach and warms your spirit.|r",
                "|cFFFF9900You savor every bite, feeling less empty inside.|r"
            },
            emote = {
                "takes a hearty bite and looks satisfied.",
                "chews their food slowly, savoring the taste.",
                "eats with clear relief as hunger fades away."
            }
        },
        drink = {
            print = {
                "|cFFFF9900Cool water runs down your throat, refreshing you.|r",
                "|cFFFF9900You take a long gulp, quenching your thirst.|r",
                "|cFFFF9900Your mouth no longer feels parched.|r"
            },
            emote = {
                "takes a long gulp of water, looking refreshed.",
                "drinks deeply, easing their thirst.",
                "sips water slowly, savoring the cool sensation."
            }
        },
        wash = {
            print = {
                "|cFFFF9900Water splashes over you, washing away grime.|r",
                "|cFFFF9900You scrub away the dirt and feel cleaner.|r",
                "|cFFFF9900The scent of sweat fades as you freshen up.|r"
            },
            emote = {
                "washes themselves, removing grime and filth.",
                "cleans up thoroughly, looking refreshed.",
                "takes a moment to wash, smelling much better."
            }
        },
        sleep = {
            print = {
                "|cFFFF9900You rest your eyes and drift into peaceful sleep.|r",
                "|cFFFF9900The weight of fatigue melts away as you relax.|r",
                "|cFFFF9900You stretch, yawn and settle into deep rest.|r"
            },
            emote = {
                "closes their eyes, settling into a peaceful rest.",
                "yawns and drifts off to sleep.",
                "lies down and begins to breathe deeply as they sleep."
            }
        },
        relieve = {
            print = {
                "|cFFFF9900Relief washes over you as your bladder empties.|r",
                "|cFFFF9900You find a discreet spot and feel comfortable again.|r",
                "|cFFFF9900The pressure eases, leaving you much more at ease.|r"
            },
            emote = {
                "steps aside to relieve themselves in privacy.",
                "looks visibly more relaxed after finding relief.",
                "returns looking far less uncomfortable than before."
            }
        }
    }
}