util.AddNetworkString("mcs_augments")

concommand.Add("mcs_augment", function(ply, _, args)
	if not IsValid(ply) then return end

	local augmentID = args[1]
	if not augmentID then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Please include a valid damage type id.")
		return
	end

	local swep = args[2]
	local success = ply:MCS_SetAugment(augmentID, swep)

	local message = "Couldn't set your augment, sorry :("
	if success then
		if swep then
			message = string.format("Set %s's augment to %s.", swep, augmentID)
		else
			message = string.format("Set your current weapon's augment to %s.", augmentID)
		end
	end

	ply:PrintMessage(HUD_PRINTCONSOLE, message)
end, nil, "Add an augment to your current weapon.", FCVAR_NONE)

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