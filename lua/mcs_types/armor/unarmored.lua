local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "unarmored"
TYPE.ServerName = "Unarmored"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(128, 128, 128)

TYPE.Symbols = { "X", "X" }
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

MCS.RegisterType(TYPE)