local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-penetrating"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

function TYPE:EffectInstantDamage(_, dmg)
	if not IsValid(dmg) then return end
	dmg:ScaleDamage(3)
end

MCS.RegisterType(TYPE)