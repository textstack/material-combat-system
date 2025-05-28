-- MCS_GetArmor() and friends are located in mcs_framework/util! this folder is for health and armor *types*

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
		healthTypeID = MCS.GetConVar("mcs_sv_default_health_type"):GetString()
	end

	return MCS.HealthType(healthTypeID)
end

--[[ Set the entity's health type by id
	inputs:
		id - id of the health type to set
	output:
		whether the operation was successful
	usage:
		clientside, use this to request a health type for the player
		serverside, use this to set the health type of an entity
--]]
function ENTITY:MCS_SetHealthType(id)
	if not MCS.HealthType(id) then return false end

	if CLIENT then
		if self ~= LocalPlayer() then return false end

		net.Start("mcs_healtharmor")
		net.WriteBool(true)
		net.WriteString(id)
		net.SendToServer()

		return true
	end

	local switchFrom = self:MCS_GetHealthTypeValue("OnSwitchFrom")
	if switchFrom and self:MCS_GetEnabled() then
		switchFrom(self)
	end

	self:SetNWString("MCS_HealthType", id)

	local switchTo = MCS.HealthTypeValue(id, "OnSwitchTo")
	if switchTo and self:MCS_GetEnabled() then
		switchTo(self)
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
		armorTypeID = MCS.GetConVar("mcs_sv_default_armor_type"):GetString()
	end

	return MCS.ArmorType(armorTypeID)
end

--[[ Set the entity's armor type by id
	inputs:
		id - id of the armor type to set
	output:
		whether the operation was successful
	usage:
		clientside, use this to request an armor type for the player
		serverside, use this to set the armor type of an entity
--]]
function ENTITY:MCS_SetArmorType(id)
	if not MCS.ArmorType(id) then return false end

	if CLIENT then
		if self ~= LocalPlayer() then return false end

		net.Start("mcs_healtharmor")
		net.WriteBool(false)
		net.WriteString(id)
		net.SendToServer()

		return true
	end

	local switchFrom = self:MCS_GetArmorTypeValue("OnSwitchFrom")
	if switchFrom and self:MCS_GetEnabled() then
		switchFrom(self)
	end

	self:SetNWString("MCS_ArmorType", id)

	local switchTo = MCS.ArmorTypeValue(id, "OnSwitchTo")
	if switchTo and self:MCS_GetEnabled() then
		switchTo(self)
	end
end