timer.Create("MCS_CheckUserInfo", 1, 0, function()
	local default = MCS.GetConVar("mcs_sv_enable_by_default"):GetBool()
	local force = MCS.GetConVar("mcs_sv_force"):GetBool()

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
	ply.MCS_HasSetHealthType = nil
	ply.MCS_HasSetArmorType = nil
	ply.MCS_HasSetAugments = nil
end)

concommand.Add("mcs_set_health_type", function(ply, _, args)
	if not IsValid(ply) then return end

	local pass, message = ply:MCS_SetHealthType(args[1])

	if pass then
		local health = "mcs.health." .. args[1] .. ".name"

		ply:MCS_Notify("mcs.system.set_health_type", health)
	else
		ply:MCS_Notify(message)
	end
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

	local pass, message = ply:MCS_SetArmorType(args[1])

	if pass then
		local armor = "mcs.armor." .. args[1] .. ".name"

		ply:MCS_Notify("mcs.system.set_armor_type", armor)
	else
		ply:MCS_Notify(message)
	end
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

	local pass, message = ply:MCS_SetAugment(args[1], args[2])

	if pass then
		local dmgType = MCS.DamageType(args[1])
		local augment = dmgType and ("mcs.damage." .. args[1] .. ".name") or "mcs.nothing"
		local swep = "#" .. (args[2] or ply:GetActiveWeapon():GetClass())

		ply:MCS_Notify("mcs.system.set_augment", swep, augment)
	else
		ply:MCS_Notify(message)
	end
end, function(cmd, arg, args)
	local autoCompletes = {}

	local cmpArg = string.Trim(args[1] or "")
	local add = args[2] and " " .. args[2] or ""

	for id, dmgType in pairs(MCS.GetDamageTypes()) do
		if dmgType.Hidden then continue end
		if not dmgType.AugmentDamage then continue end

		if string.StartsWith(id, cmpArg) then
			table.insert(autoCompletes, string.format("%s %s%s", cmd, id, add))
		end
	end

	return autoCompletes
end, "Add an augment to your current weapon.", FCVAR_NONE)