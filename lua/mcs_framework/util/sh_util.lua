local ENTITY = FindMetaTable("Entity")

--- Returns whether the entity has the combat system enabled
function ENTITY:MCS_GetEnabled()
	return self:GetNWBool("MCS_Enabled")
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

--- Capitalize a string in simple title case
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
function MCS.ToCapital(str)
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end