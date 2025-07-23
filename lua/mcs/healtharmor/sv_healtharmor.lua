util.AddNetworkString("mcs_healtharmor")
util.AddNetworkString("mcs_setmax")

net.Receive("mcs_healtharmor", function(_, ply)
	local isHealth = net.ReadBool()
	local id = net.ReadString()

	local pass, message
	if isHealth then
		pass, message = ply:MCS_SetHealthType(id)
	else
		pass, message = ply:MCS_SetArmorType(id)
	end

	if not pass then
		ply:MCS_Notify(message)
	end
end)


net.Receive("mcs_setmax", function(_, ply)
	if not ply:MCS_GetEnabled() then return end

	if net.ReadBool() then
		if ply.MCS_SetArmorCool and CurTime() - ply.MCS_SetArmorCool < 1 then return end
		ply.MCS_SetArmorCool = CurTime()

		local prevMax = ply:GetMaxArmor()
		local cur = ply:Armor()

		local givenArmor = net.ReadUInt(MCS1.SET_MAX_NET_SIZE)
		givenArmor = math.Clamp(givenArmor, 0, math.pow(2, MCS1.SET_MAX_NET_SIZE) - 1)

		ply:SetMaxArmor(givenArmor)

		if prevMax == 0 then
			ply:SetArmor(0)
		else
			ply:SetArmor((cur / prevMax) * givenArmor)
		end

		ply.MCS_MaxArmor = givenArmor
	else
		if ply.MCS_SetHealthCool and CurTime() - ply.MCS_SetHealthCool < 1 then return end
		ply.MCS_SetHealthCool = CurTime()

		local prevMax = ply:GetMaxHealth()
		local cur = ply:Health()

		local givenHealth = net.ReadUInt(MCS1.SET_MAX_NET_SIZE)
		givenHealth = math.Clamp(givenHealth, 0, math.pow(2, MCS1.SET_MAX_NET_SIZE) - 1)

		ply:SetMaxHealth(givenHealth)

		if prevMax == 0 then
			ply:SetHealth(0)
		else
			ply:SetHealth((cur / prevMax) * givenHealth)
		end

		ply.MCS_MaxHealth = givenHealth
	end
end)