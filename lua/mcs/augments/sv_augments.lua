util.AddNetworkString("mcs_augments")

net.Receive("mcs_augments", function(_, ply)
	local swep = net.ReadString()
	if ply.MCS_HasSetAugments and ply.MCS_HasSetAugments[swep] then return end

	local dmgID = net.ReadString()
	if not MCS.DamageType(dmgID) then
		dmgID = nil
	end

	ply.MCS_HasSetAugments = ply.MCS_HasSetAugments or {}
	ply.MCS_Augments = ply.MCS_Augments or {}

	ply.MCS_HasSetAugments[swep] = true
	ply.MCS_Augments[swep] = dmgID

	net.Start("mcs_augments")
	net.WriteString(swep)
	net.WriteString(dmgID or "")
	net.Send(ply)
end)