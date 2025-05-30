local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "azoic-subatomic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectFirstApplied(count)
	for _, ent in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 400)) do
		if ent == self or not ent:MCS_GetEnabled() then continue end
		self:MCS_AddTypedEffects("subatomic", count)
	end
end

MCS.RegisterType(TYPE)