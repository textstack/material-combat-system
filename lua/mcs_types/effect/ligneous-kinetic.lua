local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "ligneous-kinetic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	timer.Simple(0, function()
		if not dmg or not IsValid(self) then return end
		self:MCS_ArmorRepair(dmg:GetDamage() * count)
	end)
end

MCS.RegisterType(TYPE)