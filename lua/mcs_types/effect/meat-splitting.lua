local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-splitting"
TYPE.ServerName = "Bleed"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(0, 250, 255)

MCS.InheritType(TYPE, "loricate-penetrating")

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)