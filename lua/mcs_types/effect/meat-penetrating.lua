local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-penetrating"
TYPE.ServerName = "Strong Hit"
TYPE.Icon = "icon16/shield_delete.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.05
TYPE.Reducible = true
TYPE.InflictSound = "weapons/crossbow/hitbod1.wav"

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

MCS1.RegisterType(TYPE)
