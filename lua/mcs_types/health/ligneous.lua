local TYPE = {}

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "health"
TYPE.ID = "ligneous"
TYPE.ServerName = "Ligneous" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
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
	["splitting"] = 1.5, --the rigid fibers have poor resistance to cutting
	["kinetic"] = 0.75, --wood can sustain pretty intense wind
	["penetrating"] = 1.25, --trees take quite a lot of hail damage
	["thermal"] = 1.75, --this hp type should be the most flammable because wood is wood
	["chemical"] = 0.5, --do not salt the earth
	["voltage"] = 1, --trees are okay conductors. water content & sap.
	["subatomic"] = 0.25 --wood just sucks up isotopes for some reason. a lot of plants do.
}

-- hooks (self = player this typeset is applied to)


MCS.RegisterType(TYPE)