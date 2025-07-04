util.AddNetworkString("mcs_setmax")


net.Receive("mcs_setmax", function(_, ply)
	if not ply:MCS_GetEnabled() then return end

	if net.ReadBool() then
		if ply.MCS_SetArmorCool and CurTime() - ply.MCS_SetArmorCool < 1 then return end
		ply.MCS_SetArmorCool = CurTime()

		local prevMax = ply:GetMaxArmor()
		local cur = ply:Armor()

		local givenArmor = net.ReadUInt(MCS.SET_MAX_NET_SIZE)
		ply:SetMaxArmor(givenArmor)
		ply:SetArmor((cur / prevMax) * givenArmor)
		ply.MCS_MaxArmor = givenArmor
	else
		if ply.MCS_SetHealthCool and CurTime() - ply.MCS_SetHealthCool < 1 then return end
		ply.MCS_SetHealthCool = CurTime()

		local prevMax = ply:GetMaxHealth()
		local cur = ply:Health()

		local givenHealth = net.ReadUInt(MCS.SET_MAX_NET_SIZE)
		ply:SetMaxHealth(givenHealth)
		ply:SetHealth((cur / prevMax) * givenHealth)
		ply.MCS_MaxHealth = givenHealth
	end
end)