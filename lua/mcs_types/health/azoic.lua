local TYPE = {}

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "health"
TYPE.ID = "azoic"
TYPE.ServerName = "Azoic" -- the server doesn't have access to localization
TYPE.Icon = "icons/health/azoic.png"
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

TYPE.BloodColor = DONT_BLEED
TYPE.DamageMultipliers = {
	["splitting"] = 0.25, --you are not cutting into a rock
	["kinetic"] = 1.75, --it doesn't take much force at all to split a rock that's the size of your head with nothing but a hammer and nail. now do it with the energy of a bullet.
	["penetrating"] = 1.5, --pickaxes exist
	["thermal"] = 1.25, --thermal shock has a huge effect on these substances
	["chemical"] = 0.75, --some porous rocks completely dissolve on contact with 
	["voltage"] = 0.5, --with enough charge, you can cause microfractures on the inside of the rock.
	["subatomic"] = 1 --inorganic solids tend to heavily rely on their atomic-level structure way more than people think. Look up how borosilicate glass differs from soda-lime glass.
}

-- hooks (self = player this typeset is applied to)

MCS.RegisterType(TYPE)