local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "mechanical-splitting"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	timer.Simple(0, function()
		if not dmg or not IsValid(self) then return end

		local newDmg = DamageInfo()
		newDmg:SetDamage(dmg:GetDamage() * count * 0.15)
		newDmg:SetDamageType(DMG_BURN)

		self:TakeDamageInfo(newDmg)
	end)
end

MCS.RegisterType(TYPE)