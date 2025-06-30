local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-penetrating"
TYPE.ServerName = "Strong Hit"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(0, 179, 255)

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