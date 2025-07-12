local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-splitting"
TYPE.ServerName = "Internal Fire"
TYPE.Icon = "icon16/cut_red.png"
TYPE.Color = Color(0, 250, 255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "hl1/ambience/steamburst1.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(self) then return end

	local newDmg = DamageInfo()
	newDmg:SetDamage(dmg:GetDamage() * count * 0.15)
	newDmg:SetDamageType(DMG_BURN)

	self:TakeDamageInfo(newDmg)
end

MCS.RegisterType(TYPE)
