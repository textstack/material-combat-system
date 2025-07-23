MCS1.NPCData = MCS1.NPCData or {}

MCS1.NPC_DATA_COUNT_NET_SIZE = 16

--[[ Get the health and armor types for an entity spawnName
	inputs:
		spawnName - the spawnName to get the types of (usually the class)
	output:
		a table containing [1] the health type, [2] the armor type,
		abd [3] the augment, each entry is nil if not set
--]]
function MCS1.GetNPCData(spawnName)
	return MCS1.NPCData[spawnName] or {}
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
		MCS1.ShowHealthMenu(spawnName, manMenu)

		local healthID = MCS1.GetNPCData(spawnName)[1]
		if not healthID then return end

		local healthType = MCS1.HealthType(healthID)
		if not healthType then return end

		option:SetMaterial(MCS1.GetIconMaterial(healthType))
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
		MCS1.ShowArmorMenu(spawnName, manMenu)

		local armorID = MCS1.GetNPCData(spawnName)[2]
		if not armorID then return end

		local armorType = MCS1.ArmorType(armorID)
		if not armorType then return end

		option:SetMaterial(MCS1.GetIconMaterial(armorType))
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
		MCS1.ShowAugmentMenu(spawnName, manMenu)

		local augmentID = MCS1.GetNPCData(spawnName)[3]
		if not augmentID then return end

		local augmentType = MCS1.DamageType(augmentID)
		if not augmentType then return end

		option:SetMaterial(MCS1.GetIconMaterial(augmentType))
		option.m_Image:SetImageColor(augmentType.Color or color_white)
	end
})