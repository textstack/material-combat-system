local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "loricate-voltage"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 0
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:EffectFirstApplied()
	if self:IsPlayer() then
		self:SetVelocity(-self:GetVelocity())
		return
	end

	self:SetVelocity(vector_origin)
end

MCS.RegisterType(TYPE)