concommand.Add("mcs_set_health_type", function(ply, _, args)
	if CLIENT then return end
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
	if CLIENT then return end
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
	if CLIENT then return end
	if not IsValid(ply) then return end

	local pass, message = ply:MCS_SetAugment(args[1], args[2])

	if pass then
		local swep = "#" .. (args[2] or ply:GetActiveWeapon():GetClass())

		if args[1] == "none" then
			ply:MCS_Notify("mcs.system.remove_augment", swep)
			return
		end

		local dmgType = MCS.DamageType(args[1])
		local augment = dmgType and ("mcs.damage." .. args[1] .. ".name") or "mcs.nothing"

		ply:MCS_Notify("mcs.system.set_augment", swep, augment)
	else
		ply:MCS_Notify(message)
	end
end, function(cmd, arg, args)
	local autoCompletes = {}

	local cmpArg = string.Trim(args[1] or "")
	local add = args[2] and " " .. args[2] or ""

	local dmgTypes = MCS.GetDamageTypes()
	dmgTypes["none"] = { AugmentDamage = true }

	for id, dmgType in pairs(dmgTypes) do
		if dmgType.Hidden then continue end
		if not dmgType.AugmentDamage then continue end

		if string.StartsWith(id, cmpArg) then
			table.insert(autoCompletes, string.format("%s %s%s", cmd, id, add))
		end
	end

	return autoCompletes
end, "Add an augment to your current weapon.", FCVAR_NONE)