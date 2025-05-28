util.AddNetworkString("mcs_settings")

net.Receive("mcs_settings", function(_, ply)
	if not ply:IsSuperAdmin() then return end

	local setting = net.ReadString()

	local conVar = GetConVar("mcs_sv_" .. setting)
	if not conVar then return end

	local value = net.ReadString()
	conVar:SetString(value)
end)