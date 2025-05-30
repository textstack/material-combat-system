local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "ligneous-thermal"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

MCS.InheritType(TYPE, "plasmatic-thermal")

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:EffectFirstApplied()
	self:MCS_SetCanHeal(false)
end

function TYPE:EffectExpired()
	self:MCS_SetCanHeal(true)
end

function TYPE:PlayerSetupMove()
end

MCS.RegisterType(TYPE)