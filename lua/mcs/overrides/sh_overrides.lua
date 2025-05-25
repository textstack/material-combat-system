local PLAYER = FindMetaTable("Player")

PLAYER.MCS_OldArmor = PLAYER.MCS_OldArmor or PLAYER.Armor
function PLAYER:Armor()
	if not self:GetNWBool("MCS_Enabled") then return self:MCS_OldArmor() end

	return self:GetNWInt("MCS_Armor", 0)
end

PLAYER.MCS_OldGetMaxArmor = PLAYER.MCS_OldGetMaxArmor or PLAYER.GetMaxArmor
function PLAYER:GetMaxArmor()
	if not self:GetNWBool("MCS_Enabled") then return self:MCS_OldGetMaxArmor() end

	return self:GetNWInt("MCS_MaxArmor", 0)
end