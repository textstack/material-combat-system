util.AddNetworkString("mcs_healtharmor")

local function trySetHealthType(ply, id)
	local healthType = MCS.HealthType(id)
	if not healthType then return end

	if ply.MCS_HasSetHealthType then return end

	if id ~= ply:GetNWString("MCS_HealthType", -1) then
		ply:MCS_SetHealthType(id)
		ply.MCS_HasSetHealthType = true
	end
end

local function trySetArmorType(ply, id)
	local armorType = MCS.ArmorType(id)
	if not armorType then return end

	if ply.MCS_HasSetArmorType then return end

	local healthType = ply:MCS_GetHealthType()

	if armorType.HealthTypes and not armorType.HealthTypes[healthType.ID] then return end

	if armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[healthType.ID] then return end

	if id ~= ply:GetNWString("MCS_ArmorType", -1) then
		ply:MCS_SetArmorType(id)
		ply.MCS_HasSetArmorType = true
	end
end

net.Receive("mcs_healtharmor", function(_, ply)
	local isHealth = net.ReadBool()
	local id = net.ReadString()

	if isHealth then
		trySetHealthType(ply, id)
	else
		trySetArmorType(ply, id)
	end
end)