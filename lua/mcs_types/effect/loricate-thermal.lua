local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-thermal"
TYPE.ServerName = "Armor Damage"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 67, 0)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end
	self:MCS_ArmorDamage(dmg:GetDamage() * count)
end

MCS.RegisterType(TYPE)