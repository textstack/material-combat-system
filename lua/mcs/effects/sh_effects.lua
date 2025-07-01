MCS.CurrentEffects = MCS.CurrentEffects or {}

MCS.ENTITY_LIST_NET_SIZE = 14
MCS.EFFECT_LIST_NET_SIZE = 5
MCS.EFFECT_COUNT_NET_SIZE = 32
MCS.EFFECT_PROC_ID_NET_SIZE = 24

MCS.EFFECT_DEFAULT_TIME = math.huge
MCS.MAX_EFFECT_COUNT = 4000000000
MCS.MAX_PROC_ID = 16000000
MCS.EFFECT_PROC_TIME = 0.5

local ENTITY = FindMetaTable("Entity")

--[[ Returns all of the entity's current effects
	output:
		a table of the entity's effects in the form (ID, data)
		the important members of data are .count (number of stacks) and .procID (unique number since last procced)
		the server has some more internal variables if you check sv_effects.lua though
--]]
function ENTITY:MCS_GetEffects()
	local effectList = MCS.CurrentEffects[self:EntIndex()]
	if not effectList then return {} end

	return effectList
end