local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-voltage"
TYPE.ServerName = "Flinch"
TYPE.Icon = "icon16/lightning.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "ambient/energy/newspark05.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

function TYPE:EffectFirstApplied()
	if self:IsPlayer() then
		local a = AngleRand(-2, 2)
		a.r = 0

		self:SetEyeAngles(self:EyeAngles() + a)
	end
end

MCS1.RegisterType(TYPE)
