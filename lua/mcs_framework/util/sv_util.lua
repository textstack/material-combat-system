local PLAYER = FindMetaTable("Player")

--[[ Set a player's enabled state for the combat system
	inputs:
		enabled - whether the player has the system enabled
	example:
		jimmy:MCS_SetEnabled(true)
		-- jimmy now has MCS enabled
--]]
function PLAYER:MCS_SetEnabled(enabled)
	if enabled then
		if self:GetNWBool("MCS_Enabled") then return end

		self:SetNWInt("MCS_Armor", self:Armor())
		self:SetNWInt("MCS_MaxArmor", self:MaxArmor())

		self:SetArmor(0)

		self:SetNWBool("MCS_Enabled", true)
	else
		if not self:GetNWBool("MCS_Enabled") then return end
		self:SetNWBool("MCS_Enabled")

		self:SetArmor(self:GetNWInt("MCS_Armor"))
		self:SetMaxArmor(self:GetNWInt("MCS_MaxArmor"))

		self:SetNWInt("MCS_Armor")
		self:SetNWInt("MCS_MaxArmor")
	end
end