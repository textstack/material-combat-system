local PLAYER = FindMetaTable("Player")

PLAYER.MCS_OldSetArmor = PLAYER.MCS_OldSetArmor or PLAYER.SetArmor
function PLAYER:SetArmor(amount)
	if not self:GetNWBool("MCS_Enabled") then return self:MCS_OldSetArmor(amount) end

	self:SetNWInt("MCS_Armor", math.floor(amount))
end

PLAYER.MCS_OldSetMaxArmor = PLAYER.MCS_OldSetMaxArmor or PLAYER.SetMaxArmor
function PLAYER:SetMaxArmor(amount)
	if not self:GetNWBool("MCS_Enabled") then return self:MCS_OldSetMaxArmor(amount) end

	self:SetNWInt("MCS_MaxArmor", math.floor(amount))
end