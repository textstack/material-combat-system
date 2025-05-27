MCS.CurrentEffects = MCS.CurrentEffects or {}

MCS.ENTITY_LIST_NET_SIZE = 14
MCS.EFFECT_LIST_NET_SIZE = 5
MCS.EFFECT_COUNT_NET_SIZE = 8

MCS.EFFECT_DEFAULT_TIME = math.huge
MCS.MAX_EFFECT_COUNT = 255
MCS.EFFECT_PROC_TIME = 0.5

local ENTITY = FindMetaTable("Entity")

--[[ Returns all of the entity's current effects
	output:
		a table of the entity's effects in the form (ID, data)
--]]
function ENTITY:MCS_GetEffects()
	local effectList = MCS.CurrentEffects[self:EntIndex()]
	if not effectList then return {} end

	return effectList
end