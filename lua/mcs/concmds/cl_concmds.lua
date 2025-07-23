CreateClientConVar("mcs_enabled", 1, false, true, "Whether MCS1 is enabled (0 = false, 1 = let server decide, 2 = true).", 0, 2)

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "MCS_ResetRestrictions", function(data)
	Player(data.userid).MCS_HasSetAugments = nil
end)