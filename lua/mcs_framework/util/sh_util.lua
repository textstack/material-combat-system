local PLAYER = FindMetaTable("Player")

--- Returns whether the player has the combat system enabled
function PLAYER:MCS_GetEnabled()
	return self:GetNWBool("MCS_Enabled")
end

--- Capitalize a string in simple title case
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
function MCS.ToCapital(str)
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end