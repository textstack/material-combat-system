local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "plasmatic-penetrating"
TYPE.ServerName = "Regeneration"
TYPE.Icon = "icon16/shield_delete.png"
TYPE.Color = Color(0, 179, 255)
TYPE.InflictSound = "physics/flesh/flesh_impact_bullet2.wav"

TYPE.InflictChance = 1

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

function TYPE:EffectInstantDamage(_, dmg)
	if not IsValid(dmg) then return end
	local healAmt = dmg:GetDamage()

	self.MCS_PlasmaPenRepair = self.MCS_PlasmaPenRepair or 0
	self.MCS_PlasmaPenRepairMax = self.MCS_PlasmaPenRepair or 0
	self.MCS_PlasmaPenRepair = self.MCS_PlasmaPenRepair + healAmt
	self.MCS_PlasmaPenRepairMax = self.MCS_PlasmaPenRepairMax + healAmt
end

function TYPE:OnEffectProc()
	if not self.MCS_PlasmaPenRepair or not self.MCS_PlasmaPenRepairMax or self.MCS_PlasmaPenRepair <= 0 then
		self:MCS_RemoveEffect("plasmatic-penetrating")
		return
	end

	local repairAmt = self.MCS_PlasmaPenRepairMax / 20
	if repairAmt > self.MCS_PlasmaPenRepair then
		repairAmt = self.MCS_PlasmaPenRepair
	end

	self:MCS_Heal(repairAmt)
	self.MCS_PlasmaPenRepair = math.max(self.MCS_PlasmaPenRepair - repairAmt, 0)

	if self.MCS_PlasmaPenRepair <= 0 then
		self:MCS_RemoveEffect("plasmatic-penetrating")
		return
	end
end

function TYPE:EffectExpired()
	self.MCS_PlasmaPenRepair = nil
	self.MCS_PlasmaPenRepairMax = nil
end

MCS.RegisterType(TYPE)
