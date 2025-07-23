local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-chemical"
TYPE.ServerName = "Heavy Breathing"
TYPE.Icon = "icon16/water.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 20
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "ambient/voices/cough2.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

function TYPE:EffectFirstApplied()
	self:EmitSound("player/breathe1.wav")
	self:MCS_SetCanHeal(false)
end

function TYPE:EffectExpired()
	self:StopSound("player/breathe1.wav")
	self:MCS_SetCanHeal(true)
end

MCS1.RegisterType(TYPE)
