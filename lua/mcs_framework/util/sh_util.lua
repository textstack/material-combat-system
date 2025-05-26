local ENTITY = FindMetaTable("Entity")

--- Returns whether the entity has the combat system enabled
function ENTITY:MCS_GetEnabled()
	return self:GetNWBool("MCS_Enabled") or false
end

--- Get the armor of an entity
function ENTITY:MCS_GetArmor()
	if self:IsPlayer() then
		return self:Armor()
	end

	return self:GetNWFloat("MCS_Armor", 0)
end

--- Get the max armor of an entity
function ENTITY:MCS_GetMaxArmor()
	if self:IsPlayer() then
		return self:GetMaxArmor()
	end

	return self:GetNWFloat("MCS_MaxArmor", 100)
end

--[[ Creates a timer unique to an entity, checks if the entity is valid and supplies the entity
	inputs:
		name - name of the timer
		time - time between function executions
		repetitions - times to repeat the timer (0 for infinite)
		func - the function to execute
--]]
function ENTITY:MCS_CreateTimer(name, time, repetitions, func)
	local newName = "MCS_" .. name .. self:EntIndex()
	timer.Create(newName, time, repetitions, function()
		if not self:IsValid() then
			timer.Remove(newName)
			return
		end

		func(self)
	end)
end

--[[ Removes an entity-unique timer
	inputs:
		name - name of the timer
--]]
function ENTITY:MCS_RemoveTimer(name)
	timer.Remove("MCS_" .. name .. self:EntIndex())
end

--[[ Links up a game hook to a new type hook
	inputs:
		hookName - name of the game hook
		typeHookName - name of the new type hook
--]]
function MCS.CreateTypeHook(hookName, typeHookName)
	hook.Add(hookName, "MCS_" .. typeHookName, function(ent, ...)
		if ent:MCS_GetEnabled() then
			return ent:MCS_TypeHook(typeHookName, ...)
		end
	end)
end

--- Capitalize a string in simple title case
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
function MCS.ToCapital(str)
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end