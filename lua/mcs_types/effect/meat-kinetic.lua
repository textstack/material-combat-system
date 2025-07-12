local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-kinetic"
TYPE.ServerName = "Stop"
TYPE.Icon = "icon16/asterisk_orange.png"
TYPE.Color = Color(0, 255, 60)

MCS.InheritType(TYPE, "loricate-voltage")
TYPE.InflictSound = "physics/body/body_medium_impact_hard6.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

MCS.RegisterType(TYPE)
