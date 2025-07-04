net.Receive("mcs_augments", function()
	local swep = net.ReadString()
	local dmgID = net.ReadString()
	local ply = LocalPlayer()

	if dmgID == "" then
		dmgID = nil
	end

	ply.MCS_HasSetAugments = ply.MCS_HasSetAugments or {}
	ply.MCS_HasSetAugments[swep] = true

	ply.MCS_Augments = ply.MCS_Augments or {}
	ply.MCS_Augments[swep] = dmgID
end)