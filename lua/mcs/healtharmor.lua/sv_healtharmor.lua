util.AddNetworkString("mcs_healtharmor")

net.Receive("mcs_healtharmor", function(_, ply)
	local isHealth = net.ReadBool()
	local id = net.ReadString()

	local pass, message
	if isHealth then
		pass, message = ply:MCS_SetHealthType(id)
	else
		pass, message = ply:MCS_SetArmorType(id)
	end

	if not pass then
		ply:MCS_Notify(message)
	end
end)