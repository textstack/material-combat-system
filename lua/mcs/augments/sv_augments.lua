util.AddNetworkString("mcs_augments")

net.Receive("mcs_augments", function(_, ply)
	local swep = net.ReadString()
	local dmgID = net.ReadString()

	ply:MCS_SetAugment(dmgID, swep)
end)