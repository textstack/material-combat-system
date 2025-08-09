local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-penetrating"
TYPE.ServerName = "Shockwave"
TYPE.Icon = "icon16/shield_delete.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/concrete/boulder_impact_hard1.wav"

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end

	local newDmg = DamageInfo()
	newDmg:SetDamage(dmg:GetDamage() * count)
	newDmg:SetDamageType(DMG_SONIC)

	self:TakeDamageInfo(newDmg)
end

MCS1.RegisterType(TYPE)
