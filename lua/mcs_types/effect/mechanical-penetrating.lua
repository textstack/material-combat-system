local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-penetrating"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:OnDeath(count)
	self:EmitSound("ambient/explosions/explode_1.wav")
	util.BlastDamage(nil, self, self:WorldSpaceCenter(), count * 59, self:GetMaxHealth() * 0.05 * count)
end

MCS.RegisterType(TYPE)