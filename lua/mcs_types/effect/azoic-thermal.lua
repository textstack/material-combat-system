local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "azoic-thermal"
TYPE.ServerName = "Glowing"
TYPE.Icon = "icon16/weather_sun.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "weapons/crossbow/bolt_load1.wav"
TYPE.NoTimerResets = true

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["azoic"] = true
}

function TYPE:EffectFirstApplied(count)
	self:MCS_CreateTimer("azoic-thermal", 0, 1, function()
		for _, ent in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 400)) do
			if ent == self or not ent:MCS_GetEnabled() then continue end
			ent:MCS_AddTypedEffects("thermal", count)
		end
	end)
end

MCS1.RegisterType(TYPE)
