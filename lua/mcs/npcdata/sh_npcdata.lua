MCS.NPCData = MCS.NPCData or {}

MCS.NPC_DATA_COUNT_NET_SIZE = 16

--[[ Get the health and armor types for an entity spawnName
	inputs:
		spawnName - the spawnName to get the types of (usually the class)
	output:
		a table containing [1] the health type, [2] the armor type,
		abd [3] the augment, each entry is nil if not set
--]]
function MCS.GetNPCData(spawnName)
	return MCS.NPCData[spawnName] or {}
end

properties.Add("mcs_set_health", {
	MenuLabel = "#mcs.ui.set_class_health",
	Order = 1898,
	MenuIcon = "icon16/heart.png",

	Filter = function(self, ent, ply)
		if not ply:IsSuperAdmin() then return false end
		if not IsValid(ent) then return false end
		if ent:IsPlayer() then return false end
		if not ent:IsNPC() and not ent:IsNextBot() then return false end
		if gamemode.Call("CanProperty", ply, "mcs_set_health", ent) == false then return false end

		return true
	end,
	Action = function()
	end,
	MenuOpen = function(_, option, ent)
		local spawnName = ent:MCS_GetSpawnName()

		local manMenu = option:AddSubMenu()
		MCS.ShowHealthMenu(spawnName, manMenu)

		local healthID = MCS.GetNPCData(spawnName)[1]
		if not healthID then return end

		local healthType = MCS.HealthType(healthID)
		if not healthType then return end

		option:SetMaterial(MCS.GetIconMaterial(healthType))
		option.m_Image:SetImageColor(healthType.Color or color_white)
	end
})

properties.Add("mcs_set_armor", {
	MenuLabel = "#mcs.ui.set_class_armor",
	Order = 1899,
	MenuIcon = "icon16/shield.png",

	Filter = function(self, ent, ply)
		if not ply:IsSuperAdmin() then return false end
		if not IsValid(ent) then return false end
		if ent:IsPlayer() then return false end
		if not ent:IsNPC() and not ent:IsNextBot() then return false end
		if gamemode.Call("CanProperty", ply, "mcs_set_armor", ent) == false then return false end

		return true
	end,
	Action = function()
	end,
	MenuOpen = function(_, option, ent)
		local spawnName = ent:MCS_GetSpawnName()

		local manMenu = option:AddSubMenu()
		MCS.ShowArmorMenu(spawnName, manMenu)

		local armorID = MCS.GetNPCData(spawnName)[2]
		if not armorID then return end

		local armorType = MCS.ArmorType(armorID)
		if not armorType then return end

		option:SetMaterial(MCS.GetIconMaterial(armorType))
		option.m_Image:SetImageColor(armorType.Color or color_white)
	end
})

properties.Add("mcs_set_augment", {
	MenuLabel = "#mcs.ui.set_class_augment",
	Order = 1900,
	MenuIcon = "icon16/gun.png",

	Filter = function(self, ent, ply)
		if not ply:IsSuperAdmin() then return false end
		if not IsValid(ent) then return false end
		if ent:IsPlayer() then return false end
		if not ent:IsNPC() and not ent:IsNextBot() then return false end
		if gamemode.Call("CanProperty", ply, "mcs_set_augment", ent) == false then return false end

		return true
	end,
	Action = function()
	end,
	MenuOpen = function(_, option, ent)
		local spawnName = ent:MCS_GetSpawnName()

		local manMenu = option:AddSubMenu()
		MCS.ShowAugmentMenu(spawnName, manMenu)

		local augmentID = MCS.GetNPCData(spawnName)[3]
		if not augmentID then return end

		local augmentType = MCS.DamageType(augmentID)
		if not augmentType then return end

		option:SetMaterial(MCS.GetIconMaterial(augmentType))
		option.m_Image:SetImageColor(augmentType.Color or color_white)
	end
})