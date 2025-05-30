local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-voltage"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

local ang = Angle(2, 2, 0)

function TYPE:EffectFirstApplied()
	if self:IsPlayer() then
		self:SetEyeAngles(self:EyeAngles() + AngleRand(-1, 1) * ang)
	end
end

MCS.RegisterType(TYPE)