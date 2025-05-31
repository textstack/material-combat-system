MCS.Types = MCS.Types or {}

local ENTITY = FindMetaTable("Entity")

local function lTypeHook(ply, _type, eventName, ...)
	if not _type then return end

	local func = _type[eventName]
	if not func then return end

	this = _type

	return func(ply, ...)
end

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
	if not self:MCS_GetEnabled() then return end

	local healthResult = lTypeHook(self, self:MCS_GetHealthType(), eventName, ...)
	if healthResult ~= nil then return healthResult end

	local armorResult = lTypeHook(self, self:MCS_GetArmorType(), eventName, ...)
	if armorResult ~= nil then return armorResult end

	for id, data in pairs(self:MCS_GetEffects()) do
		local effectResult = lTypeHook(self, MCS.EffectType(id), eventName, data.count, ...)
		if effectResult ~= nil then return effectResult end
	end
end

--[[ Execute a function for a specific type
	inputs:
		set - the set of the type object (health, armor, effect, etc.)
		id - the id of the type
		eventName - the name of the event to execute
		... - anything that the function needs
	overload-inputs:
		type - the type object to execute the event on
		eventName - the name of the event to execute
		... - anything that the function needs
	output:
		whatever the function returned
	note:
		unlike MCS_TypeHook(), this function does NOT automatically grab the count for effects.
		if you make a local type hook for an effect, you need to include the count as the first argument yourself.
--]]
function ENTITY:MCS_LocalTypeHook(set, id, eventName, ...)
	if not self:MCS_GetEnabled() then return end

	if type(set) == "string" then
		if not set then return end

		local tbl = MCS.Types[set]
		if not tbl then return end

		local _type = tbl[id]
		if not _type then return end

		local func = _type[eventName]
		if not func then return end

		this = _type

		return func(self, ...)
	end

	return lTypeHook(self, set, id, eventName, ...)
end

--[[ Links up a game hook to a new type hook
	inputs:
		hookName - name of the game hook
		typeHookName - name of the new type hook
--]]
function MCS.CreateGameTypeHook(hookName, typeHookName)
	hook.Add(hookName, "MCS_" .. typeHookName, function(ent, ...)
		if ent:MCS_GetEnabled() then
			return ent:MCS_TypeHook(typeHookName, ...)
		end
	end)
end

--[[ Links up a game hook to a new type hook, supplying the local player
	inputs:
		hookName - name of the game hook
		typeHookName - name of the new type hook
--]]
if CLIENT then
	function MCS.CreateClientTypeHook(hookName, typeHookName)
		hook.Add(hookName, "MCS_" .. typeHookName, function(...)
			if IsValid(LocalPlayer()) and LocalPlayer():MCS_GetEnabled() then
				return LocalPlayer():MCS_TypeHook(typeHookName, ...)
			end
		end)
	end
end

local inheritTypes = {}

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

	if TYPE._InheritedType then
		if MCS_LOADED then
			local inheritType = typeSet[TYPE._InheritedType]
			if inheritType then
				table.Inherit(TYPE, inheritType)
			end
		else
			inheritTypes[TYPE.Set] = inheritTypes[TYPE.Set] or {}
			inheritTypes[TYPE.Set][TYPE.ID] = true
		end
	end

	typeSet[TYPE.ID] = TYPE
end

--[[ Make a type object inherit values from a different type
	inputs:
		id - id of the type to inherit from
	usage:
		you have a type that's similar to another
		this doesn't work with chains of inheritance!
--]]
function MCS.InheritType(TYPE, id)
	TYPE._InheritedType = id
end

--[[
	For each type set:
		there is a function to get the type from id
			ie. MCS.HealthType(id)
		there is a function to get a value from id
			ie. MCS.HealthTypeValue(id, key)
		there is a function to get every type of the set
			ie. MCS.GetHealthTypes()
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
		if not id then return end

		return MCS.Types[typeSet][id]
	end

	MCS[MCS.ToCapital(typeSet) .. "TypeValue"] = function(id, key)
		if not id or not key then return end

		local TYPE = MCS.Types[typeSet][id]
		if not TYPE then return end

		return TYPE[key]
	end

	MCS["Get" .. MCS.ToCapital(typeSet) .. "Types"] = function()
		return MCS.Types[typeSet]
	end

	local subdir = "mcs_types/" .. typeSet .. "/"

	local files = file.Find(subdir .. "*", "LUA")
	for _, fl in ipairs(files) do
		includeTypeSet(fl, subdir, typeSet)
	end
end

for set, types in pairs(inheritTypes) do
	local typeSet = MCS.Types[set]
	if not typeSet then continue end

	for id, _ in pairs(types) do
		local TYPE = typeSet[id]
		if not TYPE or not TYPE._InheritedType then continue end

		local inheritType = typeSet[TYPE._InheritedType]
		if inheritType then
			table.Inherit(TYPE, inheritType)
		end
	end
end

inheritTypes = nil