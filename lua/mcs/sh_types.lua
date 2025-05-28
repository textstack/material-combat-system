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
	if not self:MCS_GetEnabled() then return end

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

	for id, data in pairs(self:MCS_GetEffects()) do
		local effectEvent = MCS.EffectTypeValue(id, eventName)
		if not effectEvent then continue end

		local result = effectEvent(self, data.count, ...)
		if result ~= nil then return result end
	end
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

--[[ Links up a game hook to a new type hook, supplying the local player
	inputs:
		hookName - name of the game hook
		typeHookName - name of the new type hook
--]]
if CLIENT then
	function MCS.CreateClientTypeHook(hookName, typeHookName)
		hook.Add(hookName, "MCS_" .. typeHookName, function(...)
			if LocalPlayer():MCS_GetEnabled() then
				return LocalPlayer():MCS_TypeHook(typeHookName, ...)
			end
		end)
	end
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
