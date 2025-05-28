util.AddNetworkString("mcs_augments")

net.Receive("mcs_augments", function(_, ply)
	local swep = net.ReadString()
	local dmgID = net.ReadString()

	local pass, message = ply:MCS_SetAugment(dmgID, swep)

	if not pass then
		ply:MCS_Notify(message)
	end
end)