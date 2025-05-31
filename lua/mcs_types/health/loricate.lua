local TYPE = {}

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "health"
TYPE.ID = "loricate"
TYPE.ServerName = "Loricate" -- the server doesn't have access to localization
TYPE.Icon = "icons/health/loricate.png"
TYPE.Color = color_white

-- health-specific elements

--[[
Damage key:
    1.75: softball-sized hole in your body for every hit (ligneous creature vs flamethrower)
	1.5: each hit rips limbs off of your body without much effort (bullets against unarmored meat)
	1.25: very quickly lethal (spear stuck in torso)
    1.0: things can get nasty (knife fight)
    0.75: unlikely to kill you as fast as a knife would (being pummeled to death by somebody's bare hands)
    0.5: can kill you if you get caught off guard (being tazed to death or experiencing an unfortunately long fire proc)
    0.25: what doesn't kill you probably kills you later! (continuous x-ray attack against meat)
]]--

TYPE.BloodColor = BLOOD_COLOR_ANTLION --hopefully this has the fleck particles
TYPE.DamageMultipliers = {
	["splitting"] = 0.75, --splitting isn't known for penetrating outer shells, especially not shells extending your whole outside
	["kinetic"] = 0.5, --your chosen carapace's shape distributes intense force
	["penetrating"] = 1.75, --penetrated bullets have nothing to interrupt movement once they've penetrated
	["thermal"] = 0.25, --to get to your important parts, it has to go through your outer surface first.
	["chemical"] = 1.5, --your surface's breathing holes are extremely vulnerable to reactions. see: how dish soap kills bees
	["voltage"] = 1, --your outer carapace is neutral against voltage
	["subatomic"] = 1.25 --radiation quickly hollows out bones, so there's no telling what it'll do to your exoskeleton.
}

-- hooks (self = player this typeset is applied to)


MCS.RegisterType(TYPE)