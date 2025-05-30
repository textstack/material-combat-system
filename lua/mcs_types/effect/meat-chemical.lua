local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-chemical"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 20
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

function TYPE:EffectFirstApplied()
	self:EmitSound("player/breathe1.wav")
end

function TYPE:EffectExpired()
	self:StopSound("player/breathe1.wav")
end

MCS.RegisterType(TYPE)