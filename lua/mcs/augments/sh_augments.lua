local ENTITY = FindMetaTable("Entity")

--[[ Gives an entity's augment for the current damage instance
	inputs:
		inflictor - the weapon used to deal the damage, or nil if no weapon was used
	output:
		the damage type id for the augment, or nil if there is none
--]]
function ENTITY:MCS_GetCurrentAugment(inflictor)
	if not self:IsPlayer() then
		return self.MCS_Augment
	end

	if not self.MCS_Augments then return end
	if not IsValid(inflictor) then return end

	return self.MCS_Augments[inflictor:GetClass()]
end