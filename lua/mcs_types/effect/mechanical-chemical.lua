local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-chemical"
TYPE.ServerName = "Malfunction"
TYPE.Icon = "icon16/cog_delete.png"
TYPE.Color = Color(255,255,255)

MCS1.InheritType(TYPE, "mechanical-voltage")

TYPE.DamageTypes = {
	["chemical"] = true
}

MCS1.RegisterType(TYPE)
