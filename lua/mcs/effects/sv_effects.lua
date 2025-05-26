util.AddNetworkString("mcs_effects")

--- Network the entire effects table
function MCS.SendEffects()
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

	net.Broadcast()
end

--- Network the effects for a single entity and broadcast
function ENTITY:MCS_BumpEffects()
	self:MCS_CreateTimer("bumpEffects", 0, 1, function()
		net.Start("mcs_effects")
		net.WriteBool(false)

		net.WriteUInt(1, MCS.ENTITY_LIST_NET_SIZE)
		net.WriteUInt(self:EntIndex(), MCS.ENTITY_LIST_NET_SIZE)

		local effectList = self:MCS_GetEffects()
		net.WriteUInt(table.Count(effectList), MCS.EFFECT_LIST_NET_SIZE)
		for effectID, data in pairs(effectList) do
			net.WriteString(effectID)
			net.WriteUInt(data.count, MCS.EFFECT_COUNT_NET_SIZE)
		end

		net.Broadcast()
	end)
end

--[[ Add an effect to an entity
	inputs:
		id - the id of the effect to add
		amount - the amount of stacks to add, default 1
--]]
function ENTITY:MCS_AddEffect(id, amount)
	amount = amount or 1

	local result = self:MCS_TypeHook("OnApplyEffect", id, amount)
	if result ~= nil then return end

	local effectList = self:MCS_GetEffects()
	local effectType = MCS.EffectType(id)

	effectList[id] = effectList[id] or {
		count = 0,
		speed = 0,
		time = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME,
		runningTime = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME
	}

	effectList[id].count = math.min(count + amount, MCS.MAX_EFFECT_COUNT)
	effectList[id].speed = math.max(speed, count)

	if not effectList[id].applied then
		local func = MCS.EffectTypeValue(id, "EffectFirstApplied")
		if func then
			func(self, amount)
		end

		effectList[id].applied = true
	end

	MCS.CurrentEffects[self:EntIndex()] = effectList

	self:MCS_BumpEffects()
end

--[[ Remove an effect from an entity
	inputs:
		id - the id of the effect to remove
		amount - the amount of stacks to remove, or nil to remove all stacks
--]]
function ENTITY:MCS_RemoveEffect(id, amount)
	local effectList = self:MCS_GetEffects()
	local effectData = effectList[id]
	if not effectData then return end

	amount = amount or math.huge
	local newCount = effectData.count - amount

	if newCount < 0 then
		local func = MCS.EffectTypeValue(id, "EffectExpired")
		if func then
			func(self, effectData.count)
		end

		MCS.CurrentEffects[self:EntIndex()][id] = nil
	else
		effectData.count = newCount
	end
end

--- Clear all effects from an entity
function ENTITY:MCS_ClearEffects()
	local effectList = self:MCS_GetEffects()
	for effectID, data1 in pairs(effectList) do
		local func = MCS.EffectTypeValue(effectID, "EffectExpired")
		if func then
			func(self, data1.count)
		end
	end

	MCS.CurrentEffects[self:EntIndex()] = {}
	self:MCS_BumpEffects()
end

timer.Create("MCS_EffectProc", MCS.EFFECT_PROC_TIME, 0, function()
	for entID, effectList in pairs(MCS.CurrentEffects) do
		local ent = Entity(entID)
		if not IsValid(ent) or not ent:MCS_GetEnabled() then
			MCS.CurrentEffects[entID] = nil
			continue
		end

		for effectID, data in pairs(effectList) do
			-- the time shrink as the stack increases would need to be tested
			data.runningTime = data.runningTime - MCS.EFFECT_PROC_TIME * (data.speed * 0.5 + 0.5)
			if data.runningTime > 0 then continue end

			data.runningTime = data.time
			data.count = data.count - 1

			if data.count > 0 then continue end

			local func = MCS.EffectTypeValue(effectID, "EffectExpired")
			if func then
				func(ent, 0)
			end

			MCS.CurrentEffects[entID][effectID] = nil
		end

		ent:MCS_TypeHook("OnEffectProc")
	end

	MCS.SendEffects()
end)