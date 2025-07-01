local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-chemical"
TYPE.ServerName = "Malfunction"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 0, 190)

MCS.InheritType(TYPE, "mechanical-voltage")

TYPE.DamageTypes = {
	["chemical"] = true
}

MCS.RegisterType(TYPE)