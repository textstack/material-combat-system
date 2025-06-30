local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-thermal"
TYPE.ServerName = "Burning"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 67, 0)

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