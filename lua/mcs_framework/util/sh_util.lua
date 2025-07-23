MCS1.NOTIFY_FORMAT_NET_SIZE = 6
MCS1.SET_MAX_NET_SIZE = 22

vector_one = Vector(1, 1, 1)

local ENTITY = FindMetaTable("Entity")

--- Returns whether the entity has the combat system enabled
function ENTITY:MCS_GetEnabled()
	if self:GetMaxHealth() <= 0 then return false end

	local enabled = self:GetNWBool("MCS_Enabled", -1)

	if enabled == -1 then
		if self:IsNextBot() or self:IsNPC() or self:IsPlayer() then
			enabled = MCS1.GetConVar("mcs_sv_enable_by_default"):GetBool()
		else
			enabled = false
		end
	end

	return enabled or false
end

--- get the spawn name of an entity, or the class if they don't have one
function ENTITY:MCS_GetSpawnName()
	local spawnName = self:GetNWString("NPCName", -1)
	if spawnName == -1 then
		spawnName = self:GetClass()
	end

	return spawnName
end

--- Get the armor of an entity
function ENTITY:MCS_GetArmor()
	if self:IsPlayer() then
		return self:Armor()
	end

	local maxHealth = self:GetMaxHealth()
	if maxHealth <= 0 then return 0 end

	local result = self:MCS_TypeHook("EntityGetArmor")
	if result ~= nil then return result end

	return self:GetNWFloat("MCS_Armor", maxHealth)
end

--- Get the max armor of an entity
function ENTITY:MCS_GetMaxArmor()
	if self:IsPlayer() then
		return self:GetMaxArmor()
	end

	local maxHealth = self:GetMaxHealth()
	if maxHealth <= 0 then return 0 end

	local result = self:MCS_TypeHook("EntityGetMaxArmor")
	if result ~= nil then return result end

	return self:GetNWFloat("MCS_MaxArmor", maxHealth)
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

--[[ Notify a player.
	inputs:
		tag - the localization tag of the message
		... - anything the message needs to be formatted with
--]]
function ENTITY:MCS_Notify(tag, ...)
	if not tag then return end
	if not self:IsPlayer() then return end

	if CLIENT then
		self:ChatPrint(MCS1.L(tag, ...))
	else
		local items = {...}

		net.Start("mcs_notify")
		net.WriteString(tag)
		net.WriteUInt(table.Count(items), MCS1.NOTIFY_FORMAT_NET_SIZE)
		for _, item in ipairs(items) do
			net.WriteString(tostring(item))
		end
		net.Send(self)
	end
end

--- Capitalize a string in simple title case
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
function MCS1.ToCapital(str)
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
function MCS1.Magnitude(value, magnitude, center)
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
function MCS1.VanillaMag(value, _type)
	return MCS1.Magnitude(value, 1 - MCS1.GetConVar("mcs_sv_damage_vanillaness"):GetFloat(), vanillaMagDefaults[_type])
end

--[[ Applies one frame's worth of a dampening effect on a value from A to B
	inputs:
		speed - speed of the transition
		from - the old value
		to - the target value
	usage:
		whenever you want to smooth out a changing value or animate something moving without knowledge of when it will change
==]]
function MCS1.Dampen(speed, from, to)
	return Lerp(1 - math.exp(-speed * FrameTime()), from, to)
end

--HACK: allow compatability with mods that use the old global name if Mac's Simple NPCS is not installed
hook.Add("PostGamemodeLoaded", "MCS_MCSBackupTable", function()
	if MCS.Spawns and MCS.Config and MCS.Themes then return end

	table.Merge(MCS1, MCS)
	MCS = MCS1
end)