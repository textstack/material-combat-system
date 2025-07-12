local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-thermal"
TYPE.ServerName = "Burning"
TYPE.Icon = "icon16/fire.png"
TYPE.Color = Color(255,255,255)

MCS.InheritType(TYPE, "meat-plasmatic-thermal")
TYPE.InflictSound = "ambient/fire/ignite.wav"

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
