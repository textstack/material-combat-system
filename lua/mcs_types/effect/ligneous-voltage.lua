local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-voltage"
TYPE.ServerName = "Armor Bypass"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(248, 196, 0)

TYPE.MaxStacks = 1
TYPE.BaseTime = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:OnApplyEffect(_, effectType)
	if effectType.ID == "ligneous-voltage" then return true end
end

function TYPE:HandleArmorReduction()
	return true
end

MCS.RegisterType(TYPE)