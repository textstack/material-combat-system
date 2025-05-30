local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "azoic-voltage"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.75
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	timer.Simple(0, function()
		if not dmg or not IsValid(self) then return end
		local amt = dmg:GetDamage() * count * math.random()
		self:MCS_ArmorDamage(amt)
		self:MCS_Heal(amt)
	end)
end

MCS.RegisterType(TYPE)