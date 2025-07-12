local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-voltage"
TYPE.ServerName = "Armor Bypass"
TYPE.Icon = "icon16/lightning.png"
TYPE.Color = Color(255,255,255)

TYPE.MaxStacks = 1
TYPE.BaseTime = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.InflictSound = "physics/wood/wood_strain3.wav"

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
