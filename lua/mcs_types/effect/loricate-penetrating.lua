local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "loricate-penetrating"
TYPE.ServerName = "Bleed"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

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