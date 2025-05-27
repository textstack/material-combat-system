util.AddNetworkString("mcs_effects")

local cfgSpeedMagnitude = CreateConVar("mcs_sv_effect_speed_magnitude", 0.5, FCVAR_ARCHIVE, "The magnitude of stack decay speed. (0 = nothing, 1 = a lot)", 0.0, 1.0)
local cfgSpeedFalloff = CreateConVar("mcs_sv_effect_speed_falloff", 1.0, FCVAR_ARCHIVE, "How much the stack decay speed drops per stack applied.")
local cfgFullStackTimer = CreateConVar("mcs_sv_effect_full_stack_timer", 0, FCVAR_ARCHIVE, "Whether an expired stack timer should immediately remove the effect regardless of stack count.", 0, 1)

local ENTITY = FindMetaTable("Entity")

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

		net.WriteUInt(table.Count(bumps), MCS.ENTITY_LIST_NET_SIZE)
		for entID, _ in pairs(bumps) do
			local effectList = MCS.CurrentEffects[entID] or {}

			net.WriteUInt(entID, MCS.ENTITY_LIST_NET_SIZE)
			net.WriteUInt(table.Count(effectList), MCS.EFFECT_LIST_NET_SIZE)
			for effectID, data in pairs(effectList) do
				net.WriteString(effectID)
				net.WriteUInt(data.count, MCS.EFFECT_COUNT_NET_SIZE)
			end
		end

		net.Broadcast()

		bumps = {}
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
		frac = 0,
		time = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME,
		runningTime = effectType.BaseTime or MCS.EFFECT_DEFAULT_TIME
	}

	effectList[id].count = math.min(count + amount, MCS.MAX_EFFECT_COUNT)
	effectList[id].speed = math.max(speed - amount * cfgSpeedFalloff:GetFloat(), count)

	if cfgFullStackTimer:GetBool() then
		runningTime = time
	end

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

		ent:MCS_TypeHook("OnEffectProc")

		for effectID, data in pairs(effectList) do
			data.runningTime = data.runningTime - MCS.EFFECT_PROC_TIME * MCS.Magnitude(data.speed, cfgSpeedMagnitude:GetFloat(), 1)
			if data.runningTime > 0 then continue end

			if cfgFullStackTimer:GetBool() then
				local func = MCS.EffectTypeValue(effectID, "EffectExpired")
				if func then
					func(ent, data.count)
				end

				MCS.CurrentEffects[entID][effectID] = nil

				continue
			end

			local reduce = math.floor(-data.runningTime / data.time) + 1

			data.frac = data.frac - data.runningTime % 1
			if data.frac >= 1 then
				data.frac = data.frac - 1
				reduce = reduce + 1
			end

			data.runningTime = data.time
			data.count = data.count - reduce

			if data.count > 0 then continue end

			local func = MCS.EffectTypeValue(effectID, "EffectExpired")
			if func then
				func(ent, 0)
			end

			MCS.CurrentEffects[entID][effectID] = nil
		end
	end

	MCS.SendEffects()
end)