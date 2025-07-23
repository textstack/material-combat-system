MCS1.CurrentEffects = MCS1.CurrentEffects or {}

MCS1.ENTITY_LIST_NET_SIZE = 14
MCS1.EFFECT_LIST_NET_SIZE = 5
MCS1.EFFECT_COUNT_NET_SIZE = 32
MCS1.EFFECT_PROC_ID_NET_SIZE = 24

MCS1.EFFECT_DEFAULT_TIME = math.huge
MCS1.MAX_EFFECT_COUNT = 4000000000
MCS1.MAX_PROC_ID = 16000000
MCS1.EFFECT_PROC_TIME = 0.5

local ENTITY = FindMetaTable("Entity")

--[[ Returns all of the entity's current effects
	output:
		a table of the entity's effects in the form (ID, data)
		the important members of data are .count (number of stacks) and .procID (unique number since last procced)
		the server has some more internal variables if you check sv_effects.lua though
--]]
function ENTITY:MCS_GetEffects()
	local effectList = MCS1.CurrentEffects[self:EntIndex()]
	if not effectList then return {} end

	return effectList
end