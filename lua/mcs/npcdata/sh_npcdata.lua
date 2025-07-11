MCS.NPCData = MCS.NPCData or {}

MCS.NPC_DATA_COUNT_NET_SIZE = 16

--[[ Get the health and armor types for an entity class
	inputs:
		class - the class to get the types of
	output:
		a table containing [1] the health type, [2] the armor type,
		abd [3] the augment, each entry is nil if not set
--]]
function MCS.GetNPCData(class)
	return MCS.NPCData[class] or {}
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
		local manMenu = option:AddSubMenu()
		MCS.ShowHealthMenu(ent:GetClass(), manMenu)
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
		local manMenu = option:AddSubMenu()
		MCS.ShowArmorMenu(ent:GetClass(), manMenu)
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
		local manMenu = option:AddSubMenu()
		MCS.ShowAugmentMenu(ent:GetClass(), manMenu)
	end
})