local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "kevlar"
TYPE.ServerName = "Kevlar"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 192, 128)

TYPE.Symbols = { "⛊", "⛉" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.25,
	["kinetic"] = 0.75,
	["penetrating"] = 0.25,
	["thermal"] = 0.75,
	["chemical"] = 0.75,
	["electricity"] = 0.5,
	["subatomic"] = 1.0
}
TYPE.DrainRate = {
	["splitting"] = 1.0,
	["kinetic"] = 0.25,
	["penetrating"] = 1.5,
	["thermal"] = 0.25,
	["chemical"] = 2.0,
	["electricity"] = 0.25,
	["subatomic"] = 0.25
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)