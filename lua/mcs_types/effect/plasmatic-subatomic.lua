local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "plasmatic-subatomic"
TYPE.ServerName = "Life Pierce"
TYPE.Icon = "icon16/bricks.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 1
TYPE.Reducible = true
TYPE.InflictSound = "physics/surfaces/underwater_impact_bullet2.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectFirstApplied()
	self:MCS_TypelessDamage(self:GetMaxHealth() / 1000)
end

MCS1.RegisterType(TYPE)
