local ENTITY = FindMetaTable("Entity")

--[[ Set an entity's enabled state for the combat system
	inputs:
		enabled - whether the player has the system enabled
	example:
		jimmy:MCS_SetEnabled(true)
		-- jimmy now has MCS enabled
--]]
function ENTITY:MCS_SetEnabled(enabled)
	if enabled then
		if self:GetNWBool("MCS_Enabled") then return end
		self:SetNWBool("MCS_Enabled", true)
	else
		if not self:GetNWBool("MCS_Enabled") then return end
		self:SetNWBool("MCS_Enabled")
	end
end

--- Set the armor of an entity
function ENTITY:MCS_SetArmor(amt)
	if self:IsPlayer() then
		self:SetArmor(amt)
		return
	end

	self:SetNWFloat("MCS_Armor", amt)
end

--- Set the max armor of an entity
function ENTITY:MCS_SetMaxArmor(amt)
	if self:IsPlayer() then
		self:SetMaxArmor(amt)
		return
	end

	self:SetNWFloat("MCS_MaxArmor", amt)
end