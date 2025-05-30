local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-kinetic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

MCS.InheritType(TYPE, "loricate-voltage")

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)