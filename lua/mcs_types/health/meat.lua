local TYPE = {}

TYPE.Set = "health"
TYPE.ID = "meat"
TYPE.ServerName = "Meat"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 64, 64)

TYPE.BloodColor = BLOOD_COLOR_RED
TYPE.DamageMultipliers = {
	["splitting"] = 1.50,
	["kinetic"] = 1.0,
	["penetrating"] = 1.25,
	["thermal"] = 0.75,
	["chemical"] = 0.75,
	["electricity"] = 1.25,
	["subatomic"] = 0.25
}

MCS.RegisterType(TYPE)