-- MCS_GetArmor() and friends are located in mcs_framework/util! this folder is for health and armor *types*

--[[ determines whether the specified armor type can be equipped given the healthtype
	inputs:
		armorType - the armor type to check
		healthTypeOrID - the health type to check against
	output:
		whether the armor type inputted would be equippable
--]]
function MCS1.IsEquippableArmor(armorType, healthTypeOrID)
	if not armorType then return false end
	if not healthTypeOrID then return true end

	local hpID = type(healthTypeOrID) == "string" and healthTypeOrID or healthTypeOrID.ID

	if armorType.HealthTypes and not armorType.HealthTypes[hpID] then return false end
	if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[hpID] then return false end

	return true
end

local ENTITY = FindMetaTable("Entity")

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
	local healthTypeID = self:GetNWString("MCS_HealthType", -1)
	if healthTypeID == -1 then
		local data = MCS1.GetNPCData(self:MCS_GetSpawnName())
		if data[1] then
			healthTypeID = data[1]
		else
			healthTypeID = MCS1.GetConVar("mcs_sv_default_health_type"):GetString()
		end
	end

	return MCS1.HealthType(healthTypeID)
end

--[[ Set the entity's health type by id
	inputs:
		id - id of the health type to set
		force - serverside, set to true to bypass the one-per-life restriction for players
	outputs:
		whether the operation was successful
		the tag for the error message if failed
	usage:
		clientside, use this to request a health type for the player
		serverside, use this to set the health type of an entity
--]]
function ENTITY:MCS_SetHealthType(id, force)
	if not MCS1.HealthType(id) then return false, "mcs.error.invalid_health_type" end
	if id == self:GetNWString("MCS_HealthType", -1) then return true end

	if CLIENT then
		if self ~= LocalPlayer() then return false, "mcs.error.self_only" end
		if not force and self:GetNWBool("MCS_HasSetHealthType") then return false, "mcs.error.already_set_health_type" end

		net.Start("mcs_healtharmor")
		net.WriteBool(true)
		net.WriteString(id)
		net.SendToServer()

		return true
	end

	if self:IsPlayer() then
		if not force and self:GetNWBool("MCS_HasSetHealthType") then return false, "mcs.error.already_set_health_type" end
		self:SetNWBool("MCS_HasSetHealthType", true)
	end

	self:MCS_LocalTypeHook(self:MCS_GetHealthType(), "OnSwitchFrom")

	self:SetNWString("MCS_HealthType", id)

	self:MCS_LocalTypeHook("health", id, "OnSwitchTo")

	if not MCS1.IsEquippableArmor(self:MCS_GetArmorType(), id) then
		self:MCS_SetArmorType(MCS1.GetConVar("mcs_sv_default_armor_type"):GetString(), true)
	end

	if self:IsPlayer() then
		local color = self:MCS_GetHealthTypeValue("BloodColor")
		if color then
			self:SetBloodColor(color)
		end
	end

	return true
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
	local armorTypeID = self:GetNWString("MCS_ArmorType", -1)
	if armorTypeID == -1 then
		local data = MCS1.GetNPCData(self:MCS_GetSpawnName())
		if data[2] then
			armorTypeID = data[2]
		else
			armorTypeID = MCS1.GetConVar("mcs_sv_default_armor_type"):GetString()
		end
	end

	return MCS1.ArmorType(armorTypeID)
end

--[[ Set the entity's armor type by id
	inputs:
		id - id of the armor type to set
		force - serverside, set to true to bypass the one-per-life restriction for players
	outputs:
		whether the operation was successful
		the tag for the error message if failed
	usage:
		clientside, use this to request an armor type for the player
		serverside, use this to set the armor type of an entity
--]]
function ENTITY:MCS_SetArmorType(id, force)
	local armorType = MCS1.ArmorType(id)
	if not armorType then return false, "mcs.error.invalid_armor_type" end
	if id == self:GetNWString("MCS_ArmorType", -1) then return true end

	local healthType = self:MCS_GetHealthType()
	if healthType then
		if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then return false, "mcs.error.health_type_no_allow" end
		if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[healthType.ID] then return false, "mcs.error.health_type_no_allow" end
	end

	if CLIENT then
		if self ~= LocalPlayer() then return false, "mcs.error.self_only" end
		if not force and self:GetNWBool("MCS_HasSetArmorType") then return false, "mcs.error.already_set_armor_type" end

		net.Start("mcs_healtharmor")
		net.WriteBool(false)
		net.WriteString(id)
		net.SendToServer()

		return true
	end

	if self:IsPlayer() then
		if not force and self:GetNWBool("MCS_HasSetArmorType") then return false, "mcs.error.already_set_armor_type" end
		self:SetNWBool("MCS_HasSetArmorType", true)
	end

	self:MCS_LocalTypeHook(self:MCS_GetArmorType(), "OnSwitchFrom")

	self:SetNWString("MCS_ArmorType", id)

	self:MCS_LocalTypeHook("armor", id, "OnSwitchTo")

	return true
end