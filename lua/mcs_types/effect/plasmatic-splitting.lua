local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "plasmatic-splitting"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectInstantDamage(_, dmg)
	dmg:ScaleDamage(1.25)

	local healAmt = dmg:GetDamage() / 10

	self.MCS_PlasmaSplRepair = self.MCS_PlasmaSplRepair or 0
	self.MCS_PlasmaSplRepairMax = self.MCS_PlasmaSplRepair or 0
	self.MCS_PlasmaSplRepair = self.MCS_PlasmaSplRepair + healAmt
	self.MCS_PlasmaSplRepairMax = self.MCS_PlasmaSplRepairMax + healAmt
end

function TYPE:OnEffectProc()
	if not self.MCS_PlasmaSplRepair or not self.MCS_PlasmaSplRepairMax or self.MCS_PlasmaSplRepair <= 0 then
		self:MCS_RemoveEffect("plasmatic-splitting")
		return
	end

	local repairAmt = self.MCS_PlasmaSplRepairMax / 20
	if repairAmt > self.MCS_PlasmaSplRepair then
		repairAmt = self.MCS_PlasmaSplRepair
	end

	self:MCS_Heal(repairAmt)
	self.MCS_PlasmaSplRepair = math.max(self.MCS_PlasmaSplRepair - repairAmt, 0)

	if self.MCS_PlasmaSplRepair <= 0 then
		self:MCS_RemoveEffect("plasmatic-splitting")
		return
	end
end

function TYPE:EffectExpired()
	self.MCS_PlasmaSplRepair = nil
	self.MCS_PlasmaSplRepairMax = nil
end

MCS.RegisterType(TYPE)