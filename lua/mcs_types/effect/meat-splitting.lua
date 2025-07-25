local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-splitting"
TYPE.ServerName = "Bleed"
TYPE.Icon = "icon16/cut_red.png"
TYPE.Color = Color(255,255,255)

MCS1.InheritType(TYPE, "loricate-penetrating")
TYPE.InflictSound = "ambient/machines/slicer1.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS1.RegisterType(TYPE)
