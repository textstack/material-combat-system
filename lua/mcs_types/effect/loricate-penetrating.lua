local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-penetrating"
TYPE.ServerName = "Bleed"
TYPE.Icon = "icon16/shield_delete.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 5
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_bloody_break.wav"

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:OnEffectProc(count)
	self:MCS_TypelessDamage(count)
end

MCS.RegisterType(TYPE)
