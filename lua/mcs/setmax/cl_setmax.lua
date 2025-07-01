--[[ Set the max health or armor of the local player.
	inputs:
		amount - value to set the max to
		isArmor - true for max armor, false for max health
--]]
function MCS.SetMax(amount, isArmor)
	net.Start("mcs_setmax")
	net.WriteBool(isArmor or false)
	net.WriteUInt(amount, MCS.SET_MAX_NET_SIZE)
	net.SendToServer()
end