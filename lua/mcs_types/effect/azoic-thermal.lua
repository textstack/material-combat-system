local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-thermal"
TYPE.ServerName = "Burning"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 67, 0)

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