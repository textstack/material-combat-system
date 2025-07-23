net.Receive("mcs_npcdata", function()
	if net.ReadBool() then
		MCS1.NPCData = {}
	end

	local count = net.ReadUInt(MCS1.NPC_DATA_COUNT_NET_SIZE)
	for i = 1, count do
		local spawnName = net.ReadString()
		local healthType = net.ReadString()
		local armorType = net.ReadString()
		local augment = net.ReadString()

		if healthType == "" and armorType == "" and augment == "" then
			MCS1.NPCData[spawnName] = nil
		else
			MCS1.NPCData[spawnName] = {}

			if healthType == "" then
				MCS1.NPCData[spawnName][1] = nil
			else
				MCS1.NPCData[spawnName][1] = healthType
			end

			if armorType == "" then
				MCS1.NPCData[spawnName][2] = nil
			else
				MCS1.NPCData[spawnName][2] = armorType
			end

			if augment == "" then
				MCS1.NPCData[spawnName][3] = nil
			else
				MCS1.NPCData[spawnName][3] = augment
			end
		end
	end
end)

--[[ Request to set the health and armor types for an entity spawnName, requires superadmin
	inputs:
		spawnName - the spawnName to set
		healthID - the health type to set (optional)
		armorID - the armor type to set (optional)
		augmentID - the damage type id to set for an augment (optional)
	return:
		whether the operation was successful
--]]
function MCS1.SetNPCData(spawnName, healthID, armorID, augmentID)
	if not LocalPlayer():IsSuperAdmin() then return false end

	MCS1.NPCData[spawnName] = MCS1.NPCData[spawnName] or {}
	local data = MCS1.NPCData[spawnName]

	if healthID then
		if healthID == "" then
			data[1] = nil
		else
			data[1] = healthID
		end
	end

	if armorID then
		if armorID == "" then
			data[2] = nil
		else
			data[2] = armorID
		end
	end

	if augmentID then
		if augmentID == "" then
			data[3] = nil
		else
			data[3] = augmentID
		end
	end

	net.Start("mcs_npcdata")
	net.WriteString(spawnName)
	net.WriteString(data[1] or "")
	net.WriteString(data[2] or "")
	net.WriteString(data[3] or "")
	net.SendToServer()

	return true
end

--[[ Generates and shows a menu of health types to set an entity spawnName to
	inputs:
		spawnName - the spawnName to set the data for
		menu - the menu to add the elements to
--]]
function MCS1.ShowHealthMenu(spawnName, dMenu)
	local data = MCS1.GetNPCData(spawnName)

	if data[1] then
		local none = dMenu:AddOption("#mcs.default", function()
			MCS1.SetNPCData(spawnName, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in pairs(MCS1.GetHealthTypes()) do
		if id == data[1] then continue end

		local opt = dMenu:AddOption(string.format("#mcs.health.%s.name", id), function()
			MCS1.SetNPCData(spawnName, id)
		end)

		opt:SetMaterial(MCS1.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

--[[ Generates and shows a menu of armor types to set an entity spawnName to
	inputs:
		spawnName - the spawnName to set the data for (usually the class)
		menu - the menu to add the elements to
--]]
function MCS1.ShowArmorMenu(spawnName, dMenu)
	local data = MCS1.GetNPCData(spawnName)

	if data[2] then
		local none = dMenu:AddOption("#mcs.default", function()
			MCS1.SetNPCData(spawnName, nil, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in pairs(MCS1.GetArmorTypes()) do
		if id == data[2] then continue end

		if not MCS1.IsEquippableArmor(_type, data[1]) then
			continue
		end

		local opt = dMenu:AddOption(string.format("#mcs.armor.%s.name", id), function()
			MCS1.SetNPCData(spawnName, nil, id)
		end)

		opt:SetMaterial(MCS1.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

--[[ Generates and shows a menu of damage types to set an entity spawnName to
	inputs:
		spawnName - the spawnName to set the data for (usually the class)
		menu - the menu to add the elements to
--]]
function MCS1.ShowAugmentMenu(spawnName, dMenu)
	local data = MCS1.GetNPCData(spawnName)

	if data[3] then
		local none = dMenu:AddOption("#mcs.none", function()
			MCS1.SetNPCData(spawnName, nil, nil, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in SortedPairsByMemberValue(MCS1.GetDamageTypes(), "Order") do
		if id == data[3] then continue end

		local opt = dMenu:AddOption(string.format("#mcs.damage.%s.name", id), function()
			MCS1.SetNPCData(spawnName, nil, nil, id)
		end)

		opt:SetMaterial(MCS1.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

local function setIcon(opt, datum, typeName, fallback)
	if not datum then
		opt:SetIcon(fallback)
		return
	end

	local _type = MCS1[typeName .. "Type"](datum)
	if not _type then
		opt:SetIcon(fallback)
		return
	end

	opt:SetMaterial(MCS1.GetIconMaterial(_type))
	opt.m_Image:SetImageColor(_type.Color or color_white)
end

--[[ Adds 3 options to a DMenu for setting health/armor/augment
	inputs:
		spawnName - the spawnName to set the data for (usually the class)
		menu - the menu to add the elements to
--]]
function MCS1.ShowNPCMenus(spawnName, dMenu)
	local data = MCS1.GetNPCData(spawnName)

	local hpMenu, hpParent = dMenu:AddSubMenu("#mcs.ui.set_class_health")
	MCS1.ShowHealthMenu(spawnName, hpMenu)
	setIcon(hpParent, data[1], "Health", "icon16/heart.png")

	local apMenu, apParent = dMenu:AddSubMenu("#mcs.ui.set_class_armor")
	MCS1.ShowArmorMenu(spawnName, apMenu)
	setIcon(apParent, data[2], "Armor", "icon16/shield.png")

	local augMenu, augParent = dMenu:AddSubMenu("#mcs.ui.set_class_augment")
	MCS1.ShowAugmentMenu(spawnName, augMenu)
	setIcon(augParent, data[3], "Damage", "icon16/gun.png")
end

hook.Add("SpawnmenuIconMenuOpen", "MCS_NPCspawnNameSetting", function(dMenu, icon, contentType)
	if contentType ~= "npc" then return end
	if not LocalPlayer():IsSuperAdmin() then return end

	MCS1.ShowNPCMenus(icon:GetSpawnName(), dMenu)
end)