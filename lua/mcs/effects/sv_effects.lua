util.AddNetworkString("mcs_effects")

local ENTITY = FindMetaTable("Entity")

--- Network the entire effects table
function MCS1.SendEffects()
	net.Start("mcs_effects", true)
	net.WriteBool(true)

	net.WriteUInt(table.Count(MCS1.CurrentEffects), MCS1.ENTITY_LIST_NET_SIZE)
	for entID, effectList in pairs(MCS1.CurrentEffects) do
		net.WriteUInt(entID, MCS1.ENTITY_LIST_NET_SIZE)
		net.WriteUInt(table.Count(effectList), MCS1.EFFECT_LIST_NET_SIZE)
		for effectID, data in pairs(effectList) do
			net.WriteString(effectID)
			net.WriteUInt(data.count, MCS1.EFFECT_COUNT_NET_SIZE)
			net.WriteUInt(data.procID or 0, MCS1.EFFECT_PROC_ID_NET_SIZE)
		end
	end

	net.Broadcast()
end

local bumps = {}

--- Network the effects for a single entity and broadcast
function ENTITY:MCS_BumpEffects()
	bumps[self:EntIndex()] = true

	timer.Create("MCS_BumpEffects", 0, 1, function()
		for entID, _ in pairs(bumps) do
			if not IsValid(Entity(entID)) then
				bumps[entID] = nil
			end
		end

		net.Start("mcs_effects", true)
		net.WriteBool(false)

		net.WriteUInt(table.Count(bumps), MCS1.ENTITY_LIST_NET_SIZE)
		for entID, _ in pairs(bumps) do
			local effectList = MCS1.CurrentEffects[entID] or {}

			net.WriteUInt(entID, MCS1.ENTITY_LIST_NET_SIZE)
			net.WriteUInt(table.Count(effectList), MCS1.EFFECT_LIST_NET_SIZE)
			for effectID, data in pairs(effectList) do
				net.WriteString(effectID)
				net.WriteUInt(data.count, MCS1.EFFECT_COUNT_NET_SIZE)
				net.WriteUInt(data.procID or 0, MCS1.EFFECT_PROC_ID_NET_SIZE)
			end
		end

		net.Broadcast()

		bumps = {}
	end)
end

--[[ Adds effects to an entity according to health and damage type
	inputs:
		damageTypeID - the ID of the damage type for the effect
		amount - the amount of stacks to add, default 1
--]]
function ENTITY:MCS_AddTypedEffects(damageTypeID, amount)
	local healthType = self:MCS_GetHealthType()
	if not healthType then return end

	for effectID, effectType in pairs(MCS1.GetEffectTypes()) do
		if effectType.HealthTypes and not effectType.HealthTypes[healthType.ID] then continue end
		if effectType.HealthTypeBlacklist and effectType.HealthTypeBlacklist[healthType.ID] then continue end
		if effectType.DamageTypes and not effectType.DamageTypes[damageTypeID] then continue end
		if effectType.DamageTypeBlacklist and effectType.DamageTypeBlacklist[damageTypeID] then continue end

		self:MCS_AddEffect(effectID, amount)
	end
end

--[[ Removes effects from an entity according to damage type
	inputs:
		damageTypeID - the ID of the damage type for the effect
		amount - the amount of stacks to remove, nil for all
--]]
function ENTITY:MCS_RemoveTypedEffects(damageTypeID, amount)
	-- ignoring health type to avoid complications if players switch health types mid-effect
	for effectID, effectType in pairs(MCS1.GetEffectTypes()) do
		if effectType.DamageTypes and not effectType.DamageTypes[damageTypeID] then continue end
		if effectType.DamageTypeBlacklist and effectType.DamageTypeBlacklist[damageTypeID] then continue end

		self:MCS_RemoveEffect(effectID, amount)
	end
end

--[[ Add an effect to an entity
	inputs:
		id - the id of the effect to add
		amount - the amount of stacks to add, default 1
	returns:
		true if the effect applied, false otherwise
--]]
function ENTITY:MCS_AddEffect(id, amount)
	if not self:Alive() then return end

	local effectType = MCS1.EffectType(id)
	if not effectType then return end

	amount = amount or 1
	amount = math.min(amount, effectType.MaxStacks or MCS1.MAX_EFFECT_COUNT, MCS1.MAX_EFFECT_COUNT)
	if amount == 0 then return end

	local effectList = self:MCS_GetEffects()

	local oldCount = effectList[id] and effectList[id].count or 0
	if self:MCS_LocalTypeHook(effectType, "EffectCanApply", oldCount, amount) == false then return false end

	if self:MCS_TypeHook("OnApplyEffect", effectType, amount) ~= nil then return false end

	if effectType.InflictSound then
		self:EmitSound(effectType.InflictSound, nil, nil, 0.75, CHAN_BODY)
	end

	if effectType.BaseTime and effectType.BaseTime <= 0 then
		self:MCS_LocalTypeHook(effectType, "EffectFirstApplied", amount)
		self:MCS_LocalTypeHook(effectType, "EffectApplied", amount, amount)
		self:MCS_LocalTypeHook(effectType, "EffectExpired", amount)

		return true
	end

	effectList[id] = effectList[id] or {
		count = 0,
		speed = 0,
		frac = 0,
		time = effectType.BaseTime or MCS1.EFFECT_DEFAULT_TIME,
		runningTime = effectType.BaseTime or MCS1.EFFECT_DEFAULT_TIME
	}

	effectList[id].procID = math.random(0, MCS1.MAX_PROC_ID)
	effectList[id].count = math.min(effectList[id].count + amount, effectType.MaxStacks or MCS1.MAX_EFFECT_COUNT, MCS1.MAX_EFFECT_COUNT)
	effectList[id].speed = math.max(effectList[id].speed - amount * MCS1.GetConVar("mcs_sv_effect_speed_falloff"):GetFloat(), effectList[id].count)

	if not effectType.NoTimerResets and (effectType.FullStackTimer or effectList[id].count == effectType.MaxStacks or MCS1.GetConVar("mcs_sv_effect_full_stack_timer"):GetBool()) then
		effectList[id].runningTime = effectList[id].time
	end

	if not effectList[id].applied then
		self:MCS_LocalTypeHook(effectType, "EffectFirstApplied", amount)
		effectList[id].applied = true
	end

	self:MCS_LocalTypeHook(effectType, "EffectApplied", effectList[id].count, amount)

	MCS1.CurrentEffects[self:EntIndex()] = effectList

	self:MCS_BumpEffects()

	return true
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
		self:MCS_LocalTypeHook("effect", id, "EffectExpired", effectData.count)
		MCS1.CurrentEffects[self:EntIndex()][id] = nil
	else
		effectData.count = newCount
	end
end

--- Clear all effects from an entity
function ENTITY:MCS_ClearEffects()
	local effectList = self:MCS_GetEffects()
	for effectID, data in pairs(effectList) do
		self:MCS_LocalTypeHook("effect", effectID, "EffectExpired", data.count)
	end

	MCS1.CurrentEffects[self:EntIndex()] = {}
	self:MCS_BumpEffects()
end

timer.Create("MCS_EffectProc", MCS1.EFFECT_PROC_TIME, 0, function()
	for entID, effectList in pairs(MCS1.CurrentEffects) do
		local ent = Entity(entID)
		if not IsValid(ent) or not ent:MCS_GetEnabled() then
			MCS1.CurrentEffects[entID] = nil
			continue
		end

		ent:MCS_TypeHook("OnEffectProc")

		for effectID, data in pairs(effectList) do
			local effectType = MCS1.EffectType(effectID)

			if effectType.FullStackTimer or MCS1.GetConVar("mcs_sv_effect_full_stack_timer"):GetBool() then
				data.runningTime = data.runningTime - MCS1.EFFECT_PROC_TIME
				if data.runningTime > 0 then continue end

				ent:MCS_LocalTypeHook(effectType, "EffectStackReduced", data.count, data.count)
				ent:MCS_LocalTypeHook(effectType, "EffectExpired", data.count)

				MCS1.CurrentEffects[entID][effectID] = nil

				continue
			end

			data.runningTime = data.runningTime - MCS1.EFFECT_PROC_TIME * MCS1.Magnitude(data.speed, MCS1.GetConVar("mcs_sv_effect_speed_magnitude"):GetFloat(), 1)
			if data.runningTime > 0 then continue end

			local reduce = math.floor(-data.runningTime / data.time) + 1

			data.frac = data.frac - data.runningTime % 1
			if data.frac >= 1 then
				data.frac = data.frac - 1
				reduce = reduce + 1
			end

			data.runningTime = data.time
			data.count = math.max(data.count - reduce, 0)

			ent:MCS_LocalTypeHook(effectType, "EffectStackReduced", data.count, reduce)

			if data.count > 0 then continue end

			ent:MCS_LocalTypeHook(effectType, "EffectExpired", 0)

			MCS1.CurrentEffects[entID][effectID] = nil
		end
	end

	MCS1.SendEffects()
end)