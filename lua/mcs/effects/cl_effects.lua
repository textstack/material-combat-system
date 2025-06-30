net.Receive("mcs_effects", function()
	local wipe = net.ReadBool()

	local incoming = {}

	local entCount = net.ReadUInt(MCS.ENTITY_LIST_NET_SIZE)
	for i = 1, entCount do
		local entID = net.ReadUInt(MCS.ENTITY_LIST_NET_SIZE)
		incoming[entID] = {}

		local effectCount = net.ReadUInt(MCS.EFFECT_LIST_NET_SIZE)
		for j = 1, effectCount do
			local effectID = net.ReadString()
			local count = net.ReadUInt(MCS.EFFECT_COUNT_NET_SIZE)

			local procID
			if wipe and MCS.CurrentEffects[entID] and MCS.CurrentEffects[entID][effectID] and MCS.CurrentEffects[entID][effectID].procID then
				procID = MCS.CurrentEffects[entID][effectID].procID
			else
				procID = math.random(0, 1000000000)
			end

			incoming[entID][effectID] = { count = count, procID = procID }
		end
	end

	if wipe then
		MCS.CurrentEffects = incoming
	else
		table.Merge(MCS.CurrentEffects, incoming, true)
	end
end)