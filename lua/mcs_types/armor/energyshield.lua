local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "energyshield"
TYPE.ServerName = "Energy Shield"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 192, 128)

TYPE.Symbols = { "⊡", "⊠" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.0,
	["kinetic"] = 0.0,
	["penetrating"] = 0.0,
	["thermal"] = 1.0,
	["chemical"] = 0.0,
	["subatomic"] = 0.25
}
TYPE.DrainRate = {
	["splitting"] = 0.75,
	["kinetic"] = 4.5,
	["penetrating"] = 2.25,
	["thermal"] = 0.25,
	["chemical"] = 0.0,
	["subatomic"] = 1.0
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)