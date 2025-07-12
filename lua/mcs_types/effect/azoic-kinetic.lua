local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-kinetic"
TYPE.ServerName = "Splash"
TYPE.Icon = "icon16/asterisk_orange.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "weapons/fx/rics/ric4.wav"

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
