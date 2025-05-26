MCS.CurrentEffects = MCS.CurrentEffects or {}

local ENTITY = FindMetaTable("Entity")

--[[ Returns all of the entity's current effects
	output:
		a table of the entity's effects in the form (ID, count)
--]]
function ENTITY:MCS_GetEffects()
	--TODO: status effects
	-- should probably be moved to its own file
	return {}
end