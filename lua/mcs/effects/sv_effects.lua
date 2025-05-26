util.AddNetworkString("mcs_effects")

--[[ Network the entire effects table
	inputs:
		ply - a player, list of players, or nil to send the data to (nil = everyone)
--]]
function MCS.SendEffects(ply)
	net.Start("mcs_effects", true)
	net.WriteBool(true)

	net.WriteUInt(table.Count(MCS.CurrentEffects), MCS.ENTITY_LIST_NET_SIZE)
	for entID, effectList in pairs(MCS.CurrentEffects) do
		net.WriteUInt(entID, MCS.ENTITY_LIST_NET_SIZE)
		net.WriteUInt(table.Count(effectList), MCS.EFFECT_LIST_NET_SIZE)
		for effectID, data in pairs(effectList) do
			net.WriteString(effectID)
			net.WriteUInt(data.count, MCS.EFFECT_COUNT_NET_SIZE)
		end
	end

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

--[[ Network the effects for a single entity and broadcast
	inputs:
		ent - the entity to broadcast its data for
--]]
function MCS.BumpEffects(ent)
	net.Start("mcs_effects")
	net.WriteBool(false)
	net.WriteUInt(1, MCS.ENTITY_LIST_NET_SIZE)
	net.WriteUInt(ent:EntIndex(), MCS.ENTITY_LIST_NET_SIZE)

	local effectList = ent:MCS_GetEffects()
	net.WriteUInt(table.Count(effectList), MCS.EFFECT_LIST_NET_SIZE)
	for effectID, data in pairs(effectList) do
		net.WriteString(effectID)
		net.WriteUInt(data.count, MCS.EFFECT_COUNT_NET_SIZE)
	end
end

--[[ Add an effect to an entity
	inputs:
		id - the id of the effect to add
		amount - the amount of stacks to add
--]]
function ENTITY:MCS_AddEffect(id, amount)
	local result = self:MCS_TypeHook("OnApplyEffect", id, amount)
	if result ~= nil then return end

	local effectList = self:MCS_GetEffects()
	local effectType = MCS.EffectType(id)

	effectList[id] = effectList[id] or {
		count = 0,
		time = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME,
		runningTime = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME
	}

	effectList[id].count = math.min(count + amount, MCS.MAX_EFFECT_COUNT)

	if not effectList[id].applied then
		local func = MCS.EffectTypeValue(id, "EffectFirstApplied")
		if func then
			func(self, amount)
		end

		effectList[id].applied = true
	end

	self:MCS_CreateTimer("bumpEffects", 0, 1, function()
		MCS.BumpEffects(self)
	end)
end

timer.Create("MCS_EffectProc", 0.25, 0, function()
	for entID, effectList in pairs(MCS.CurrentEffects) do
		local ent = Entity(entID)
		if not IsValid(ent) or not ent:MCS_GetEnabled() then
			MCS.CurrentEffects[entID] = nil
			continue
		end

		for effectID, data in pairs(effectList) do
			data.runningTime = data.runningTime - 0.25 * (data.count * 0.5 + 0.5)
			if data.runningTime <= 0 then
				data.runningTime = data.time
				data.count = data.count - 1
			end

			if data.count <= 0 then
				local func = MCS.EffectTypeValue(effectID, "EffectExpired")
				if func then
					func(ent, 0)
				end

				MCS.CurrentEffects[entID][effectID] = nil
				continue
			end
		end

		ent:MCS_TypeHook("OnEffectProc")
	end

	MCS.SendEffects()
end)