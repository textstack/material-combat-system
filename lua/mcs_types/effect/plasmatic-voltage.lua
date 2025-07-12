local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "plasmatic-voltage"
TYPE.ServerName = "Inertia"
TYPE.Icon = "icon16/lightning.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 5
TYPE.InflictChance = 0.15
TYPE.Reducible = true
TYPE.InflictSound = "ambient/levels/canals/shore1.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(dmg:GetDamageForce()) then return end
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
