local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "azoic-thermal"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:OnEffectProc()
	self:MCS_TypelessDamage(2)
end

MCS.RegisterType(TYPE)