local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "azoic-penetrating"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

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
	timer.Simple(0, function()
		if not dmg or not IsValid(self) then return end

		local newDmg = DamageInfo()
		newDmg:SetDamage(dmg:GetDamage() * count)
		newDmg:SetDamageType(DMG_SONIC)

		self:TakeDamageInfo(newDmg)
	end)
end

MCS.RegisterType(TYPE)