local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-kinetic"
TYPE.ServerName = "Splash"
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