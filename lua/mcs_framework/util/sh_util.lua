local ENTITY = FindMetaTable("Entity")

cfgEnabled = CreateConVar("mcs_sv_enable_by_default", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED, "Whether players have MCS enabled by default when they join.", 0, 1)

--- Returns whether the entity has the combat system enabled
function ENTITY:MCS_GetEnabled()
	return self:GetNWBool("MCS_Enabled", cfgEnabled:GetBool()) or false
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

--[[ Returns whether an entity-unique timer exists
	inputs:
		name - name of the timer
	output:
		whether the timer exists or not
--]]
function ENTITY:MCS_TimerExists(name)
	return timer.Exists("MCS_" .. name .. self:EntIndex())
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

--[[ Magnify a value around a starting point
	inputs:
		value - the value to be magnified
		magnitude - the magnitude (must be between 0 and 1)
		center - the 'zero' point (if magnitude == 0, then value == center)
	output:
		the magnified value
--]]
function MCS.Magnitude(value, magnitude, center)
	return (value - center) * magnitude + center
end

local vanillaMagDefaults = {
	["armorDamage"] = 0.2,
	["armorDrain"] = 0.8,
	["healthDamage"] = 1
}

--[[ Magnify a value based on the mcs_sv_damage_vanillaness convar
	inputs:
		value - the value to be magnified
		_type - can be "armorDamage", "armorDrain", or "healthDamage"
	output:
		the magnified value
	usage:
		any situation where an armor or health type has custom damage multipliers
--]]
function MCS.VanillaMag(value, _type)
	return MCS.Magnitude(value, 1 - GetConVar("mcs_sv_damage_vanillaness"):GetFloat(), vanillaMagDefaults[_type])
end