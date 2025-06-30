local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-penetrating"
TYPE.ServerName = "Jiggle"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(0, 179, 255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

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

MCS.RegisterType(TYPE)