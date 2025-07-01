net.Receive("mcs_effects", function()
	if net.ReadBool() then
		MCS.CurrentEffects = {}
	end

	local entCount = net.ReadUInt(MCS.ENTITY_LIST_NET_SIZE)
	for i = 1, entCount do
		local entID = net.ReadUInt(MCS.ENTITY_LIST_NET_SIZE)
		MCS.CurrentEffects[entID] = {}

		local effectCount = net.ReadUInt(MCS.EFFECT_LIST_NET_SIZE)
		for j = 1, effectCount do
			local effectID = net.ReadString()
			local count = net.ReadUInt(MCS.EFFECT_COUNT_NET_SIZE)
			local procID = net.ReadUInt(MCS.EFFECT_PROC_ID_NET_SIZE)

			MCS.CurrentEffects[entID][effectID] = { count = count, procID = procID }
		end
	end
end)