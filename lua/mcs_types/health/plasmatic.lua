local TYPE = {}

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "health"
TYPE.ID = "plasmatic"
TYPE.ServerName = "Plasmatic" -- the server doesn't have access to localization
TYPE.Icon = "mcs_icons/health/plasmatic.png"
TYPE.Color = Color(188, 95, 211)

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

TYPE.BloodColor = BLOOD_COLOR_YELLOW
TYPE.DamageMultipliers = {
	["splitting"] = 0.75, --you may eventually kill it by cutting it into chunks small enough that they cannot survive.
	["kinetic"] = 0.5, --you can squash a ghost, but now you just have a pretty angry ghost.
	["penetrating"] = 0.25, --you can put a hole into a slime, but it really isn't going to change it very much.
	["thermal"] = 1, --from slimes, to ghosts, and divine entities, fire averages out to be pretty much neutral.
	["chemical"] = 1.5, --demons, though resistant to physical attack, very easily absorb holy water. every entity in this category has an analogue.
	["voltage"] = 1.25, --These are beings of vague, wobbly energy--fluids. voltage loves fluids.
	["subatomic"] = 1.75 --egon gun
}

-- hooks (self = player this typeset is applied to)


MCS1.RegisterType(TYPE)