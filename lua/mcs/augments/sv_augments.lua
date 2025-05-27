util.AddNetworkString("mcs_augments")

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

net.Receive("mcs_augments", function(_, ply)
	local swep = net.ReadString()
	if ply.MCS_SetAugments and ply.MCS_SetAugments[swep] then return end

	local dmgID = net.ReadString()
	if not MCS.DamageType(dmgID) then
		dmgID = nil
	end

	ply.MCS_SetAugments = ply.MCS_SetAugments or {}
	ply.MCS_Augments = ply.MCS_Augments or {}

	ply.MCS_SetAugments[swep] = true
	ply.MCS_Augments[swep] = dmgID

	net.Start("mcs_augments")
	net.WriteString(swep)
	net.WriteString(dmgID or "")
	net.Send(ply)
end)