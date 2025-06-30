local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-kinetic"
TYPE.ServerName = "Knockback"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(0, 255, 60)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(dmg:GetDamageForce()) then return end
	dmg:SetDamageForce(dmg:GetDamageForce() * 10 * count)
end

MCS.RegisterType(TYPE)