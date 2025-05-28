local ENTITY = FindMetaTable("Entity")

--- Returns whether the entity has the combat system enabled
function ENTITY:MCS_GetEnabled()
	return self:GetNWBool("MCS_Enabled", MCS.GetConVar("mcs_sv_enable_by_default"):GetBool()) or false
end

--- Get the armor of an entity
function ENTITY:MCS_GetArmor()
	if self:IsPlayer() then
		return self:Armor()
	end

	if self:GetMaxHealth() <= 0 then return 0 end

	return self:GetNWFloat("MCS_Armor", 0)
end

--- Get the max armor of an entity
function ENTITY:MCS_GetMaxArmor()
	if self:IsPlayer() then
		return self:GetMaxArmor()
	end

	if self:GetMaxHealth() <= 0 then return 0 end

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
	return MCS.Magnitude(value, 1 - MCS.GetConVar("mcs_sv_damage_vanillaness"):GetFloat(), vanillaMagDefaults[_type])
end