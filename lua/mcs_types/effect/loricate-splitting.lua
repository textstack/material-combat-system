local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-splitting"
TYPE.ServerName = "Thump"
TYPE.Icon = "icon16/cut_red.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 1
TYPE.InflictSound = "npc/vort/vort_foot4.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

MCS.RegisterType(TYPE)
