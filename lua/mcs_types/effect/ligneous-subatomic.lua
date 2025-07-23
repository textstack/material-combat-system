local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-subatomic"
TYPE.ServerName = "Healing"
TYPE.Icon = "icon16/heart_add.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "ambient/materials/squeekyfloor1.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end
	self:MCS_Heal(dmg:GetDamage() * count * 2)
end
MCS1.RegisterType(TYPE)
