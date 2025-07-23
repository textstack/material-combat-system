local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "plasmatic-chemical"
TYPE.ServerName = "Chemical Burn"
TYPE.Icon = "icon16/water.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 10
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.NoTimerResets = true
TYPE.InflictSound = "ambient/levels/canals/toxic_slime_sizzle2.wav"

TYPE.DamageTypes = {
	["chemical"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:OnApplyEffect(_, effectType)
	if effectType.ID == "plasmatic-chemical" then return true end
end

function TYPE:OnEffectProc()
	self:MCS_TypelessDamage(2)
end

MCS1.RegisterType(TYPE)
