local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-voltage"
TYPE.ServerName = "Health Conversion"
TYPE.Icon = "icon16/shield_go.png"
TYPE.Color = Color(248, 196, 0)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.75
TYPE.Reducible = true
TYPE.InflictSound = "physics/concrete/concrete_block_impact_hard3.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end
	local amt = dmg:GetDamage() * count * math.random()
	self:MCS_ArmorDamage(amt)
	self:MCS_Heal(amt)
end

MCS.RegisterType(TYPE)
