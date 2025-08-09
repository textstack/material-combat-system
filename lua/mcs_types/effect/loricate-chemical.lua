local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-chemical"
TYPE.ServerName = "Death Knell"
TYPE.Icon = "icon16/water.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.InflictChance = 0.1
TYPE.MaxStacks = 20
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_bloody_impact_hard1.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:OnApplyEffect(count, effectType)
	if effectType.ID == "loricate-chemical" and count >= 20 then return true end
end

function TYPE:OnEffectProc(count)
	if count < 20 then return end

	self:MCS_TypelessDamage(self:GetMaxHealth() / 20)
end

MCS1.RegisterType(TYPE)
