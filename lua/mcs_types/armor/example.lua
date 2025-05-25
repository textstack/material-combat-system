local TYPE = {}
TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Set = "armor"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- armor-specific elements

TYPE.Symbols = { "⛊", "⛉" }
TYPE.DamageMultipliers = {
	["impact"] = 1,
	["puncture"] = 1,
	["slash"] = 1,
	["shock"] = 1,
	["heat"] = 1,
	["toxin"] = 1,
	["pressure"] = 1,
	["particle"] = 1
}
TYPE.DrainRate = {
	["impact"] = 1,
	["puncture"] = 1,
	["slash"] = 1,
	["shock"] = 1,
	["heat"] = 1,
	["toxin"] = 1,
	["pressure"] = 1,
	["particle"] = 1
}
TYPE.HealthTypes = {
	["example"] = true
}

-- hooks (self = player this typeset is applied to)

function TYPE:OnTakeDamage(dmg)
	self:Kill()
end

MCS.RegisterType(TYPE)