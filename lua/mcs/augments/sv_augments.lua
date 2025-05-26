util.AddNetworkString("mcs_augments")

net.Receive("mcs_augments", function(_, ply)
    local swep = net.ReadString()
    if ply.MCS_SetAugments and ply.MCS_SetAugments[swep] then return end

    local dmgID = net.ReadString()
    if not MCS.DamageType(dmgID) then return end

    ply.MCS_SetAugments = ply.MCS_SetAugments or {}
    ply.MCS_Augments = ply.MCS_Augments or {}

    ply.MCS_SetAugments[swep] = true
    ply.MCS_Augments[swep] = dmgID

    net.Start("mcs_augments")
    net.WriteString(swep)
    net.WriteString(dmgID)
    net.Send(ply)
end)