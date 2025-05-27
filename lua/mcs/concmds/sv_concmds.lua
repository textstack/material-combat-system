timer.Create("MCS_CheckUserInfo", 1, 0, function()
	local default = GetConVar("mcs_sv_enable_by_default"):GetBool()
	local force = GetConVar("mcs_sv_force"):GetBool()

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
	end
end)

hook.Add("PlayerSpawn", "MCS_ResetRestrictions", function(ply)
	ply.MCS_SetHealthType = nil
	ply.MCS_SetArmorType = nil
	ply.MCS_SetAugments = nil
end)

concommand.Add("mcs_set_health_type", function(ply, _, args)
	if not IsValid(ply) then return end

	local healthType = MCS.HealthType(args[1])
	if not healthType then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Please include a valid health type id.")
		return
	end

	if ply.MCS_SetHealthType then
		ply:PrintMessage(HUD_PRINTCONSOLE, "You've already set a health type this life.")
		return
	end

	if healthType.ID ~= ply:GetNWString("MCS_HealthType", -1) then
		ply:MCS_SetHealthType(healthType.ID)
		ply.MCS_SetHealthType = true
	end

	ply:PrintMessage(HUD_PRINTCONSOLE, string.format("Set your health type to %s.", string.lower(healthType.ServerName)))
end, function(cmd, arg)
	local autoCompletes = {}

	arg = string.Trim(arg)

	for id, _ in pairs(MCS.GetHealthTypes()) do
		if string.StartsWith(id, arg) then
			table.insert(autoCompletes, string.format("%s %s", cmd, id))
		end
	end

	return autoCompletes
end, "Set your MCS health type.", FCVAR_NONE)

concommand.Add("mcs_set_armor_type", function(ply, _, args)
	if not IsValid(ply) then return end

	local armorType = MCS.ArmorType(args[1])
	if not armorType then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Please include a valid armor type id.")
		return
	end

	if ply.MCS_SetArmorType then
		ply:PrintMessage(HUD_PRINTCONSOLE, "You've already set an armor type this life.")
		return
	end

	local healthType = ply:MCS_GetHealthType()

	if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Your current health type doesn't allow this armor type.")
		return
	end

	if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[healthType.ID] then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Your current health type doesn't allow this armor type.")
		return
	end

	if armorType.ID ~= ply:GetNWString("MCS_ArmorType", -1) then
		ply:MCS_SetArmorType(armorType.ID)
		ply.MCS_SetArmorType = true
	end

	ply:PrintMessage(HUD_PRINTCONSOLE, string.format("Set your armor type to %s.", string.lower(armorType.ServerName)))
end, function(cmd, arg)
	local autoCompletes = {}

	arg = string.Trim(arg)

	for id, _ in pairs(MCS.GetArmorTypes()) do
		if string.StartsWith(id, arg) then
			table.insert(autoCompletes, string.format("%s %s", cmd, id))
		end
	end

	return autoCompletes
end, "Set your MCS armor type.", FCVAR_NONE)

concommand.Add("mcs_set_augment", function(ply, _, args)
	if not IsValid(ply) then return end

	local dmgType = MCS.DamageType(args[1])
	if not dmgType then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Please include a valid damage type id.")
		return
	end

	local swep = args[2]
	local success = ply:MCS_SetAugment(dmgType.ID, swep)

	local message = "Couldn't set your augment, sorry :("
	if success then
		if swep then
			message = string.format("Set %s's augment to %s.", swep, string.lower(dmgType.ServerName))
		else
			message = string.format("Set your current weapon's augment to %s.", string.lower(dmgType.ServerName))
		end
	end

	ply:PrintMessage(HUD_PRINTCONSOLE, message)
end, function(cmd, arg, args)
	local autoCompletes = {}

	local cmpArg = string.Trim(args[1] or "")
	local add = args[2] and " " .. args[2] or ""

	for id, dmgType in pairs(MCS.GetDamageTypes()) do
		if dmgType.Hidden then continue end

		if string.StartsWith(id, cmpArg) then
			table.insert(autoCompletes, string.format("%s %s%s", cmd, id, add))
		end
	end

	return autoCompletes
end, "Add an augment to your current weapon.", FCVAR_NONE)