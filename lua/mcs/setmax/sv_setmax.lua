util.AddNetworkString("mcs_setmax")


net.Receive("mcs_setmax", function(_, ply)
	if not ply:MCS_GetEnabled() then return end

	if net.ReadBool() then
		if ply.MCS_SetArmorCool and CurTime() - ply.MCS_SetArmorCool < 1 then return end
		ply.MCS_SetArmorCool = CurTime()
		
		local GivenArmor = net.ReadUInt(MCS.SET_MAX_NET_SIZE)
		ply:SetMaxArmor(GivenArmor)
		ply:SetArmor(GivenArmor) -- TODO: If Armor has TYPE.NoArmorOnSpawn, do not set.
		ply.MCS_MaxArmor = GivenArmor
	else
		if ply.MCS_SetHealthCool and CurTime() - ply.MCS_SetHealthCool < 1 then return end
		ply.MCS_SetHealthCool = CurTime()
		
		local GivenHealth = net.ReadUInt(MCS.SET_MAX_NET_SIZE)
		ply:SetMaxHealth(GivenHealth)
		ply:SetHealth(GivenHealth)
		ply.MCS_MaxHealth = GivenHealth
	end
end)