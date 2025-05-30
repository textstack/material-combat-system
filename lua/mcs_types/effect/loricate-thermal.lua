local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "loricate-thermal"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

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
	timer.Simple(0, function()
		if not dmg or not IsValid(self) then return end
		self:MCS_ArmorDamage(dmg:GetDamage() * count)
	end)
end

MCS.RegisterType(TYPE)