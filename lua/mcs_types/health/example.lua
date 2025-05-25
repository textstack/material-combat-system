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

TYPE.BloodColor = BLOOD_COLOR_RED
TYPE.DamageMultipliers = {
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["subatomic"] = 1
}

-- hooks (self = player this typeset is applied to)

function TYPE:OnTakeDamage(dmg)
	self:Kill()
end

MCS.RegisterType(TYPE)