local TYPE = {}

-- localization entries

-- name key -> mcs.health.example.name
-- description key -> mcs.health.example.desc
-- abbreviation key -> mcs.health.example.abbr

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "health"
TYPE.ID = "mechanical"
TYPE.ServerName = "Mechanical" -- the server doesn't have access to localization
TYPE.Icon = "mcs_icons/health/mechanical.png"
TYPE.Color = Color(95, 188, 211)

-- health-specific elements

--[[
Damage key:
    1.75: softball-sized hole in your body for every hit
	1.5: each hit rips limbs off of your body without much effort (ligneous creature vs flamethrower)
	1.25: very quickly lethal (bullets against unarmored meat)
    1.0: things can get nasty (knife fight)
    0.75: unlikely to kill you as fast as a knife would (being pummeled to death by somebody's bare hands)
    0.5: can kill you if you get caught off guard (being tazed to death or experiencing an unfortunately long fire proc)
    0.25: what doesn't kill you probably kills you later! (continuous x-ray attack against meat)
]]--

TYPE.BloodColor = BLOOD_COLOR_MECH
TYPE.DamageMultipliers = {
	["splitting"] = 1, --seems wrong, but this is PURE mechanical. no armor casing means that you can sever wires.
	["kinetic"] = 1.25, --watch as every internal part is instantly bent
	["penetrating"] = 0.75, --there's more empty space inside a machine compared to a lot of other hp types.
	["thermal"] = 0.25, --try not to overheat
	["chemical"] = 1.5, --immediately sensitive to basically all liquids during normal operation
	["voltage"] = 1.75, --a computer can handle a drop of water, but the little bit of ESD from your finger can instantly kill it
	["subatomic"] = 0.5 --general system disruption can pretty quickly kill you if you let it
}

-- hooks (self = player this typeset is applied to)

MCS1.RegisterType(TYPE)