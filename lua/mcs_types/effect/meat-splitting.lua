local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-splitting"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

MCS.InheritType(TYPE, "loricate-penetrating")

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)