-- TODO: server default for enabled state, armor restrictions, only set health/armor once per life

if CLIENT then
	CreateClientConVar("mcs_enabled", 0, false, true, "Whether MCS is enabled.", 0, 1)
	CreateClientConVar("mcs_armortype", "kevlar", true, true, "Your armor type for MCS.")
	CreateClientConVar("mcs_healthtype", "meat", true, true, "Your health type for MCS.")
	return
end

timer.Create("MCS_CheckUserInfo", 1, 0, function()
	for _, ply in ipairs(player.Iterator()) do
		local enabled = ply:GetInfoNum("mcs_enabled", 0) ~= 0
		local armorTypeID = ply:GetInfo("mcs_armortype")
		local healthTypeID = ply:GetInfo("mcs_healthtype")

		if enabled ~= ply:MCS_GetEnabled() then
			ply:MCS_SetEnabled(enabled)
		end
		if armorTypeID ~= ply:GetNWString("MCS_ArmorType", -1) then
			ply:MCS_SetArmorType(armorTypeID)
		end
		if healthTypeID ~= ply:GetNWString("MCS_HealthType", -1) then
			ply:MCS_SetHealthType(healthTypeID)
		end
	end
end)