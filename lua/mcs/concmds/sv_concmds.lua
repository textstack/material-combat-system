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
	ply:SetNWBool("MCS_HasSetHealthType", false)
	ply:SetNWBool("MCS_HasSetArmorType", false)
	ply.MCS_HasSetAugments = nil

	if ply:MCS_GetEnabled() then
		local color = ply:MCS_GetHealthTypeValue("BloodColor")
		if color then
			ply:SetBloodColor(color)
		end
	end
end)