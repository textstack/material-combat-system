MCS.Typesets = MCS.Typesets or {}

local PLAYER = FindMetaTable("Player")

--- Returns the health type object for the player's current health type
function PLAYER:MCS_GetHealthType()
	local healthTypeID = self:GetNWString("MCS_HealthType", -1)
	if healthTypeID == -1 then return end

	if not MCS.Typesets.health then return end

	return MCS.Typesets.health[healthTypeID]
end

--- Returns the armor type object for the player's current armor type
function PLAYER:MCS_GetArmorType()
	local armorTypeID = self:GetNWString("MCS_ArmorType", -1)
	if armorTypeID == -1 then return end

	if not MCS.Typesets.armor then return end

	return MCS.Typesets.armor[armorTypeID]
end

--[[ Returns all of the player's current status effects
	output:
		a table of the player's status effects in the form (ID, count)
--]]
function PLAYER:MCS_GetStatusEffects()
	--TODO: status effects
	return {}
end

--[[ Execute functions from the player's types (health, armor, statuses)
	inputs:
		eventName - name of the event to execute
		... - anything that should be pushed to the functions
	output:
		whatever function returns a result
	example:
		jimmy:MCS_TypeHook("foo", "bar")
		-- jimmy has a healthtype of "law", which has the following function:
		-- foo(text) return text .. " law" end
		-- output would be "bar law"
--]]
function PLAYER:MCS_TypeHook(eventName, ...)
	local healthType = self:MCS_GetHealthType()
	if healthType and healthType[eventName] then
		local result = healthType[eventName](self, ...)
		if result ~= nil then return result end
	end

	local armorType = self:MCS_GetArmorType()
	if armorType and armorType[eventName] then
		local result = armorType[eventName](self, ...)
		if result ~= nil then return result end
	end

	for id, count in pairs(self:MCS_GetStatusEffects()) do
		local status = MCS.StatusEffect(id)
		if not status or not status[eventName] then continue end

		local result = status[eventName](self, count, ...)
		if result ~= nil then return result end
	end
end

--- gets a status effect object from its id
function MCS.StatusEffect(id)
	if not MCS.Typesets.status then return end
	return MCS.Typesets.status[id]
end

--- gets a damage object from its id
function MCS.Damage(id)
	if not MCS.Typesets.damage then return end
	return MCS.Typesets.damage[id]
end

--[[ Make a table defining a valid type object
	inputs:
		_type - the table defining the type
	usage:
		put at the end of your file that's defining a type
--]]
function MCS.RegisterType(_type)
	if type(_type) ~= "table" then
		error("Expected a table but received " .. type(_type), 2)
	end

	if not _type.Set then
		error("Types must include what set they belong to! (in 'Set')", 2)
	end

	if not _type.ID then
		error("Types must include an ID! (in 'ID')", 2)
	end

	if not _type.ServerName then
		error("Types must include a server name! (in 'ServerName')", 2)
	end

	local typeset = MCS.Typesets[_type.Set]
	if not typeset then
		error("Invalid typeset!", 2)
	end

	if _type.DoNotLoad then return end

	typeset[_type.ID] = _type
end

local function includeTypeset(fl, dir, typeset)
	if not string.EndsWith(fl, ".lua") then return end

	if SERVER then
		AddCSLuaFile(dir .. fl)
	end

	include(dir .. fl)
end

local _, dirs = file.Find("mcs_typesets/*", "LUA")
for _, typeset in ipairs(dirs) do
	MCS.Typesets[typeset] = MCS.Typesets[typeset] or {}

	local subdir = "mcs_typesets/" .. typeset .. "/"

	local files = file.Find(subdir .. "*")
	for _, fl in ipairs(files) do
		includeTypeset(fl, subdir, typeset)
	end
end
