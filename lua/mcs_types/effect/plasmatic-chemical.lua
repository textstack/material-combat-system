local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "plasmatic-chemical"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.NoTimerResets = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

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

MCS.RegisterType(TYPE)