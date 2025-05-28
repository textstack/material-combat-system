--[[ Request that a server convar be changed
    inputs:
        setting - the convar name minus the "mcs_sv_" part
        value - what to set the convar value to
    usage:
        settings ui for superadmins
--]]
function MCS.RequestSetting(setting, value)
    if not LocalPlayer():IsSuperAdmin() then
        LocalPlayer():MCS_Notify("mcs.error.settings_superadmin_only")
        return
    end

    net.Start("mcs_settings")
    net.WriteString(setting)
    net.WriteString(tostring(value))
    net.SendToServer()
end