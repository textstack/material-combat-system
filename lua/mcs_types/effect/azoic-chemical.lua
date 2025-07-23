local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-chemical"
TYPE.ServerName = "Armor Conversion"
TYPE.Icon = "icon16/water.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.75
TYPE.Reducible = true
TYPE.InflictSound = "ambient/levels/canals/toxic_slime_sizzle3.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end
	local amt = dmg:GetDamage() * count * math.random()
	self:MCS_TypelessDamage(amt)
	self:MCS_RepairArmor(amt)
end

MCS1.RegisterType(TYPE)
