local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-voltage"
TYPE.ServerName = "Stop"
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(248, 196, 0)

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
	local phys = self:GetPhysicsObject()
	if not IsValid(phys) then return end

	phys:SetVelocityInstantaneous(vector_origin)

	--[[
	if self:IsPlayer() then
		self:SetVelocity(-self:GetVelocity())
		return
	end

	self:SetVelocity(vector_origin)
	--]]
end

MCS.RegisterType(TYPE)