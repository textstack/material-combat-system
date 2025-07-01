util.AddNetworkString("mcs_setmax")

net.Receive("mcs_setmax", function(_, ply)
	if not ply:MCS_GetEnabled() then return end

	if net.ReadBool() then
		if ply.MCS_SetArmorCool and CurTime() - ply.MCS_SetArmorCool < 1 then return end
		ply.MCS_SetArmorCool = CurTime()

		ply:SetMaxArmor(net.ReadUInt(MCS.SET_MAX_NET_SIZE))
	else
		if ply.MCS_SetHealthCool and CurTime() - ply.MCS_SetHealthCool < 1 then return end
		ply.MCS_SetHealthCool = CurTime()

		ply:SetMaxHealth(net.ReadUInt(MCS.SET_MAX_NET_SIZE))
	end
end)