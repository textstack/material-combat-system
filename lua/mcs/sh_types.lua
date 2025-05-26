MCS.Types = MCS.Types or {}

local ENTITY = FindMetaTable("Entity")

--[[ Execute functions from the entity's types (health, armor, statuses)
	inputs:
		eventName - name of the event to execute
		... - anything that should be pushed to the functions
	output:
		whatever function returns a result
	usage:
		never put code specific to a type outside of that type's file
		^^ for example, never do something like jimmy:MCS_GetHealthType() == "bar"
		use this function instead
	example:
		jimmy:MCS_TypeHook("foo", "bar")
		-- jimmy has a healthtype of "law", which has the following function:
		-- foo(text) return text .. " law" end
		-- output would be "bar law"
--]]
function ENTITY:MCS_TypeHook(eventName, ...)
	local healthEvent = self:MCS_GetHealthTypeValue(eventName)
	if healthEvent then
		local result = healthEvent(self, ...)
		if result ~= nil then return result end
	end

	local armorEvent = self:MCS_GetArmorTypeValue(eventName)
	if armorEvent then
		local result = armorEvent(self, ...)
		if result ~= nil then return result end
	end

	for id, count in pairs(self:MCS_GetEffects()) do
		local effectEvent = MCS.EffectTypeValue(id, eventName)
		if not effectEvent then continue end

		local result = effectEvent(self, count, ...)
		if result ~= nil then return result end
	end
end

--[[ Get a value from a entity's health type
	inputs:
		key - the key that the value is assigned to in the type object
	output:
		the associated value, or nil if there was a problem
	example:
		jimmy:MCS_GetHealthTypeValue("ServerName")
		-- jimmy has a health type with a ServerName of Foo
		-- output would be Foo
--]]
function ENTITY:MCS_GetHealthTypeValue(key)
	local healthType = self:MCS_GetHealthType()
	if not healthType then return end

	return healthType[key]
end

--- Returns the health type object for the entity's current health type
function ENTITY:MCS_GetHealthType()
	return MCS.HealthType(self:GetNWString("MCS_HealthType", -1))
end

--- Set the entity's health type by id
function ENTITY:MCS_SetHealthType(id)
	self:SetNWString("MCS_HealthType", id)
end

--[[ Get a value from a entity's armor type
	inputs:
		key - the key that the value is assigned to in the type object
	output:
		the associated value, or nil if there was a problem
--]]
function ENTITY:MCS_GetArmorTypeValue(key)
	local armorType = self:MCS_GetArmorType()
	if not armorType then return end

	return armorType[key]
end

--- Returns the armor type object for the entity's current armor type
function ENTITY:MCS_GetArmorType()
	return MCS.ArmorType(self:GetNWString("MCS_ArmorType", -1))
end

--- Set the entity's armor type by id
function ENTITY:MCS_SetArmorType(id)
	self:SetNWString("MCS_ArmorType", id)
end

--[[ Returns all registered damage types
	output:
		a table of each damage type in the form (ID, object)
--]]
function MCS.GetDamageTypes()
	return MCS.Types.damage
end

--[[ Make a table defining a valid type object
	inputs:
		TYPE - the table defining the type
	usage:
		put at the end of your file that's defining a type
--]]
function MCS.RegisterType(TYPE)
	if type(TYPE) ~= "table" then
		error("Expected a table but received " .. type(TYPE), 2)
	end

	if not TYPE.Set then
		error("Types must include what set they belong to! (in 'Set')", 2)
	end

	if not TYPE.ID then
		error("Types must include an ID! (in 'ID')", 2)
	end

	if not TYPE.ServerName then
		error("Types must include a server name! (in 'ServerName')", 2)
	end

	local typeSet = MCS.Types[TYPE.Set]
	if not typeSet then
		error("Invalid typeSet!", 2)
	end

	if TYPE.DoNotLoad then return end

	typeSet[TYPE.ID] = TYPE
end

--[[
	For each type set:
		there is a function to get the type from id
			ie. MCS.HealthType(id)
		there is a function to get a value from id
			ie. MCS.HealthTypeValue(id, key)
--]]

local function includeTypeSet(fl, dir, typeSet)
	if not string.EndsWith(fl, ".lua") then return end

	if SERVER then
		AddCSLuaFile(dir .. fl)
	end

	include(dir .. fl)
end

local _, dirs = file.Find("mcs_types/*", "LUA")
for _, typeSet in ipairs(dirs) do
	MCS.Types[typeSet] = MCS.Types[typeSet] or {}

	MCS[MCS.ToCapital(typeSet) .. "Type"] = function(id)
		return MCS.Types[typeSet][id]
	end

	MCS[MCS.ToCapital(typeSet) .. "TypeValue"] = function(id, key)
		local TYPE = MCS.Types[typeSet][id]
		if not TYPE then return end

		return TYPE[key]
	end

	local subdir = "mcs_types/" .. typeSet .. "/"

	local files = file.Find(subdir .. "*", "LUA")
	for _, fl in ipairs(files) do
		includeTypeSet(fl, subdir, typeSet)
	end
end
