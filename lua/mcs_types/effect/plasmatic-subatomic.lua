local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "plasmatic-subatomic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectFirstApplied()
	self:MCS_TypelessDamage(self:GetMaxHealth() / 1000)
end

MCS.RegisterType(TYPE)