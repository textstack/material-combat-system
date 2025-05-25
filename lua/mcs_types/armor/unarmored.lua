local TYPE = {}
TYPE.DoNotLoad = true

TYPE.Set = "armor"
TYPE.ID = "unarmored"
TYPE.ServerName = "Unarmored"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(128, 128, 128)

TYPE.Symbols = { "X", "X" }
TYPE.DamageMultipliers = {
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["subatomic"] = 1
}
TYPE.DrainRate = {
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["subatomic"] = 1
}

MCS.RegisterType(TYPE)