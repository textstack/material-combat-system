local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-chemical"
TYPE.ServerName = "Anti-heal"
TYPE.Icon = "icon16/water.png"
TYPE.Color = color_white

TYPE.MaxStacks = 1
TYPE.BaseTime = 5
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/wood/wood_strain2.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:EffectFirstApplied()
	self:MCS_RemoveEffect("ligneous-thermal")
	self:MCS_SetCanHeal(false)
	self:MCS_SetCanRepairArmor(false)
end

function TYPE:OnApplyEffect(effect)
	if effect.ID == "ligneous-thermal" then return true end
end

function TYPE:EffectExpired()
	self:MCS_SetCanHeal(true)
	self:MCS_SetCanRepairArmor(true)
end

MCS1.RegisterType(TYPE)
