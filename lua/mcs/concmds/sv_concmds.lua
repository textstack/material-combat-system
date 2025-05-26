timer.Create("MCS_CheckUserInfo", 1, 0, function()
	local default = GetConVar("mcs_sv_enable_by_default"):GetBool()
	local force = GetConVar("mcs_sv_force"):GetBool()

	local defaultArmorType = MCS.ArmorType(GetConVar("mcs_sv_default_armor_type"):GetString())
	local defaultHealthType = MCS.HealthType(GetConVar("mcs_sv_default_health_type"):GetString())

	if not defaultArmorType then
		defaultArmorType = MCS.ArmorType("unarmored")
	end
	if not defaultHealthType then
		defaultHealthType = MCS.HealthType("meat")
	end

	for _, ply in player.Iterator() do
		local enabled
		if force then
			enabled = default
		else
			local state = ply:GetInfoNum("mcs_enabled", 0)
			if state == 1 then
				enabled = default
			else
				enabled = state > 1
			end
		end

		local armorType = MCS.ArmorType(ply:GetInfo("mcs_armortype"))
		local healthType = MCS.HealthType(ply:GetInfo("mcs_healthtype"))

		if not armorType then
			armorType = defaultArmorType
		end
		if not healthType then
			healthType = defaultHealthType
		end
		if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then
			armorType = defaultArmorType
		end

		if enabled ~= ply:MCS_GetEnabled() then
			ply:MCS_SetEnabled(enabled)
		end
		if armorType.ID ~= ply:GetNWString("MCS_ArmorType", -1) then
			ply:MCS_SetArmorType(armorType.ID)
		end
		if healthType.ID ~= ply:GetNWString("MCS_HealthType", -1) then
			ply:MCS_SetHealthType(healthType.ID)
		end
	end
end)