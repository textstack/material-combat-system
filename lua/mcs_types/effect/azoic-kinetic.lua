local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "azoic-kinetic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) then return end

	self:FireBullets({
		Damage = dmg:GetDamage(),
		Num = count,
		Spread = Vector(1000, 1000, 1000),
		Src = self:WorldSpaceCenter(),
		IgnoreEntity = self
	})
end

MCS.RegisterType(TYPE)