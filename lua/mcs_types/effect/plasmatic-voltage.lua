local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "plasmatic-voltage"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.InflictChance = 0.15
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	self.MCS_PlasmaVolForce = self.MCS_PlasmaVolForce or Vector()
	self.MCS_PlasmaVolForce = self.MCS_PlasmaVolForce + dmg:GetDamageForce() * count * 0.05
end

function TYPE:OnEffectProc()
	if not self.MCS_PlasmaVolForce then
		self:MCS_RemoveEffect("plasmatic-voltage")
		return
	end

	if self:IsPlayer() then
		self:SetVelocity(self.MCS_PlasmaVolForce)
		return
	end

	self:SetVelocity(self:GetVelocity() + self.MCS_PlasmaVolForce)
end

function TYPE:EffectExpired()
	self.MCS_PlasmaVolForce = nil
end

MCS.RegisterType(TYPE)