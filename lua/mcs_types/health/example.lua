local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Set = "health"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- health-specific elements

--[[
Damage key: 
	1.5: each hit rips limbs off of your body without much effort (ligneous creature vs flamethrower)
	1.25: very quickly lethal (bullets against unarmored meat)
    1.0: things can get nasty (knife fight)
    0.75: unlikely to kill you as fast as a knife would (being pummeled to death by somebody's bare hands)
    0.5: can kill you if you get caught off guard (being tazed to death or experiencing an unfortunately long fire proc)
    0.25: what doesn't kill you probably kills you later! (continuous x-ray attack against meat)
]]--

TYPE.BloodColor = BLOOD_COLOR_RED
TYPE.DamageMultipliers = {
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["electricity"] = 1,
	["subatomic"] = 1
}

-- hooks (self = player this typeset is applied to)

function TYPE:OnTakeDamage(dmg)
	self:Kill()
end

MCS.RegisterType(TYPE)