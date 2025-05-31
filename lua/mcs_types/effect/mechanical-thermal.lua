local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-thermal"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.MaxStacks = 10
TYPE.InflictChance = 0.15
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

local hori = Vector(0.15, 0.15, 0)

function TYPE:OnTakeDamage(count, dmg)
	local knockback = dmg:GetDamageForce()
	knockback = knockback + knockback * hori * count
	dmg:SetDamageForce(knockback)
end

MCS.RegisterType(TYPE)