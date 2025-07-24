--[[ Caching version of GLua's GetConVar
    inputs:
        conVar - the convar to get
    output:
        the convar object
--]]
local conVars = {}
function MCS1.GetConVar(conVar)
    if conVars[conVar] then
        return conVars[conVar]
    end

    local cvarObj = GetConVar(conVar)
    conVars[conVar] = cvarObj

    return cvarObj
end

local fcvarFlags = FCVAR_ARCHIVE + FCVAR_REPLICATED

-- if we get a zillion convars it may be worth replacing with a file-controlled settings system

CreateConVar("mcs_sv_enable_by_default", 1, fcvarFlags, "Whether players have MCS enabled by default when they join.", 0, 1)
CreateConVar("mcs_sv_force", 1, fcvarFlags, "Prevent players from being able to change whether MCS is enabled for them.", 0, 1)
CreateConVar("mcs_sv_effect_speed_magnitude", 0.5, fcvarFlags, "The magnitude of stack decay speed. (0 = nothing, 1 = a lot)", 0.0, 1.0)
CreateConVar("mcs_sv_effect_speed_falloff", 1.0, fcvarFlags, "How much the stack decay speed drops per stack applied.")
CreateConVar("mcs_sv_effect_full_stack_timer", 0, fcvarFlags, "Whether an expired stack timer should immediately remove the effect regardless of stack count.", 0, 1)
CreateConVar("mcs_sv_default_health_type", "meat", fcvarFlags, "The default health type for players.")
CreateConVar("mcs_sv_default_armor_type", "unarmored", fcvarFlags, "The default armor type for players.")
CreateConVar("mcs_sv_damage_vanillaness", 0.0, fcvarFlags, "How 'close to vanilla' the damage calculations should be on a scale from 0 to 1.", 0.0, 1.0)
CreateConVar("mcs_sv_hud_enable_by_default", 1, fcvarFlags, "Whether the MCS hud is enabled by default for users.", 0, 1)
CreateConVar("mcs_sv_hud_show_health_armor_by_default", 1, fcvarFlags, "Whether the MCS hud shows health and armor by default.", 0, 1)
CreateConVar("mcs_sv_targetid_default_mode", 2, fcvarFlags, "What viewtarget display mode should be the default for users (0 = off, 1 = minimal, 2 = normal)", 0, 2)
