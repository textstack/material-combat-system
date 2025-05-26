local function defaultTypes()
	local defaultArmorType = MCS.ArmorType(GetConVar("mcs_sv_default_armor_type"):GetString())
	local defaultHealthType = MCS.HealthType(GetConVar("mcs_sv_default_health_type"):GetString())

	if not defaultArmorType then
		defaultArmorType = MCS.ArmorType("unarmored")
	end
	if not defaultHealthType then
		defaultHealthType = MCS.HealthType("meat")
	end

	return defaultArmorType, defaultHealthType
end

timer.Create("MCS_CheckUserInfo", 1, 0, function()
	local default = GetConVar("mcs_sv_enable_by_default"):GetBool()
	local force = GetConVar("mcs_sv_force"):GetBool()

	local defaultArmorType, defaultHealthType = defaultTypes()

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

		if enabled ~= ply:MCS_GetEnabled() then
			ply:MCS_SetEnabled(enabled)
		end

		local setHealth
		local healthType = MCS.HealthType(ply:GetInfo("mcs_healthtype"))
		if not healthType or not ply.MCS_SetHealthType then
			healthType = defaultHealthType
		else
			setHealth = true
		end

		if healthType.ID ~= ply:GetNWString("MCS_HealthType", -1) then
			ply:MCS_SetHealthType(healthType.ID)

			if setHealth then
				ply.MCS_SetHealthType = true
			end
		end

		local setArmor
		local armorType = MCS.ArmorType(ply:GetInfo("mcs_armortype"))
		if not armorType or not ply.MCS_SetArmorType then
			armorType = defaultArmorType
		else
			setArmor = true
		end
		if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then
			armorType = defaultArmorType
		end
		if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[healthType.ID] then
			armorType = defaultArmorType
		end

		if armorType.ID ~= ply:GetNWString("MCS_ArmorType", -1) then
			ply:MCS_SetArmorType(armorType.ID)

			if setArmor then
				ply.MCS_SetArmorType = true
			end
		end
	end
end)

hook.Add("PlayerSpawn", "MCS_ResetRestrictions", function(ply)
	ply.MCS_SetHealthType = nil
	ply.MCS_SetArmorType = nil
	ply.MCS_SetAugments = nil

	local defaultArmorType, defaultHealthType = defaultTypes()

	local healthType = MCS.HealthType(ply:GetInfo("mcs_healthtype"))
	if not healthType then
		healthType = defaultHealthType
	end

	if healthType.ID ~= ply:GetNWString("MCS_HealthType", -1) then
		ply:MCS_SetHealthType(healthType.ID)
	end

	local armorType = MCS.ArmorType(ply:GetInfo("mcs_armortype"))
	if not armorType then
		armorType = defaultArmorType
	end
	if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then
		armorType = defaultArmorType
	end
	if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[healthType.ID] then
		armorType = defaultArmorType
	end

	if armorType.ID ~= ply:GetNWString("MCS_ArmorType", -1) then
		ply:MCS_SetArmorType(armorType.ID)
	end
end)