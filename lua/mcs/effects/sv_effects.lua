util.AddNetworkString("mcs_effects")

--- Send the entire effects table to a player
function MCS.SendEffects(ply)
	net.Start("mcs_effects")
end