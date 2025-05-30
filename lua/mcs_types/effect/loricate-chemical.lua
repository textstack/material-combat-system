local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "loricate-chemical"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.InflictChance = 0.1
TYPE.MaxStacks = 20
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:OnEffectProc(count)
	if count < 20 then return end

	self:MCS_TypelessDamage(self:GetMaxHealth() / 20)
end

MCS.RegisterType(TYPE)