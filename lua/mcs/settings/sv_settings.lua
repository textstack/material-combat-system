util.AddNetworkString("mcs_settings")

net.Receive("mcs_settings", function(_, ply)
	if not ply:IsSuperAdmin() then
		ply:MCS_Notify("mcs.error.settings_superadmin_only")
		return
	end

	local setting = net.ReadString()

	local conVar = MCS1.GetConVar("mcs_sv_" .. setting)
	if not conVar then
		ply:MCS_Notify("mcs.error.invalid_setting")
		return
	end

	local value = net.ReadString()
	conVar:SetString(value)
end)