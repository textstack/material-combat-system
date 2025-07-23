net.Receive("mcs_effects", function()
	if net.ReadBool() then
		MCS1.CurrentEffects = {}
	end

	local entCount = net.ReadUInt(MCS1.ENTITY_LIST_NET_SIZE)
	for i = 1, entCount do
		local entID = net.ReadUInt(MCS1.ENTITY_LIST_NET_SIZE)
		MCS1.CurrentEffects[entID] = {}

		local effectCount = net.ReadUInt(MCS1.EFFECT_LIST_NET_SIZE)
		for j = 1, effectCount do
			local effectID = net.ReadString()
			local count = net.ReadUInt(MCS1.EFFECT_COUNT_NET_SIZE)
			local procID = net.ReadUInt(MCS1.EFFECT_PROC_ID_NET_SIZE)

			MCS1.CurrentEffects[entID][effectID] = { count = count, procID = procID }
		end
	end
end)