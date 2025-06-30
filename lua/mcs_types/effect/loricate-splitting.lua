local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-splitting"
TYPE.ServerName = "Stupid Noise"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(0, 250, 255)

TYPE.BaseTime = 0
TYPE.InflictChance = 1
TYPE.InflictSound = "npc/combine_gunship/attack_start2.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

MCS.RegisterType(TYPE)