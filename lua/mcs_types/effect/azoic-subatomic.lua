local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-subatomic"
TYPE.ServerName = "Relay"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 93, 255)

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
	self:MCS_CreateTimer("azoic-subatomic", 0, 1, function()
		for _, ent in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 400)) do
			if ent == self or not ent:MCS_GetEnabled() then continue end

			ent:MCS_AddTypedEffects("subatomic", count)
		end
	end)
end

MCS.RegisterType(TYPE)