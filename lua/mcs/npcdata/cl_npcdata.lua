net.Receive("mcs_npcdata", function()
	if net.ReadBool() then
		MCS.NPCData = {}
	end

	local count = net.ReadUInt(MCS.NPC_DATA_COUNT_NET_SIZE)
	for i = 1, count do
		local class = net.ReadString()
		local healthType = net.ReadString()
		local armorType = net.ReadString()
		local augment = net.ReadString()

		if healthType == "" and armorType == "" and augment == "" then
			MCS.NPCData[class] = nil
		else
			MCS.NPCData[class] = {}

			if healthType == "" then
				MCS.NPCData[class][1] = nil
			else
				MCS.NPCData[class][1] = healthType
			end

			if armorType == "" then
				MCS.NPCData[class][2] = nil
			else
				MCS.NPCData[class][2] = armorType
			end

			if augment == "" then
				MCS.NPCData[class][3] = nil
			else
				MCS.NPCData[class][3] = augment
			end
		end
	end
end)

--[[ Request to set the health and armor types for an entity class, requires superadmin
	inputs:
		class - the class to set
		healthID - the health type to set (optional)
		armorID - the armor type to set (optional)
		augmentID - the damage type id to set for an augment (optional)
	return:
		whether the operation was successful
--]]
function MCS.SetNPCData(class, healthID, armorID, augmentID)
	if not LocalPlayer():IsSuperAdmin() then return false end

	MCS.NPCData[class] = MCS.NPCData[class] or {}
	local data = MCS.NPCData[class]

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
	net.WriteString(class)
	net.WriteString(data[1] or "")
	net.WriteString(data[2] or "")
	net.WriteString(data[3] or "")
	net.SendToServer()

	return true
end

--[[ Generates and shows a menu of health types to set an entity class to
	inputs:
		class - the class to set the data for
		menu - the menu to add the elements to
--]]
function MCS.ShowHealthMenu(class, dMenu)
	local data = MCS.GetNPCData(class)

	if data[1] then
		local none = dMenu:AddOption("#mcs.default", function()
			MCS.SetNPCData(class, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in pairs(MCS.GetHealthTypes()) do
		if id == data[1] then continue end

		local opt = dMenu:AddOption(string.format("#mcs.health.%s.name", id), function()
			MCS.SetNPCData(class, id)
		end)

		opt:SetMaterial(MCS.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

--[[ Generates and shows a menu of armor types to set an entity class to
	inputs:
		class - the class to set the data for
		menu - the menu to add the elements to
--]]
function MCS.ShowArmorMenu(class, dMenu)
	local data = MCS.GetNPCData(class)

	if data[2] then
		local none = dMenu:AddOption("#mcs.default", function()
			MCS.SetNPCData(class, nil, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in pairs(MCS.GetArmorTypes()) do
		if id == data[2] then continue end

		if data[1] and ((_type.HealthTypes and not _type.HealthTypes[data[1]]) or (_type.HealthTypeBlacklist and _type.HealthTypeBlacklist[data[1]])) then
			continue
		end

		local opt = dMenu:AddOption(string.format("#mcs.armor.%s.name", id), function()
			MCS.SetNPCData(class, nil, id)
		end)

		opt:SetMaterial(MCS.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

--[[ Generates and shows a menu of damage types to set an entity class to
	inputs:
		class - the class to set the data for
		menu - the menu to add the elements to
--]]
function MCS.ShowAugmentMenu(class, dMenu)
	local data = MCS.GetNPCData(class)

	if data[3] then
		local none = dMenu:AddOption("#mcs.none", function()
			MCS.SetNPCData(class, nil, nil, "")
		end)

		none:SetIcon("icon16/cross.png")
	end

	for id, _type in pairs(MCS.GetDamageTypes()) do
		if id == data[3] then continue end

		local opt = dMenu:AddOption(string.format("#mcs.damage.%s.name", id), function()
			MCS.SetNPCData(class, nil, nil, id)
		end)

		opt:SetMaterial(MCS.GetIconMaterial(_type))
		opt.m_Image:SetImageColor(_type.Color or color_white)
	end
end

hook.Add("SpawnmenuIconMenuOpen", "MCS_NPCClassSetting", function(dMenu, icon, contentType)
	if contentType ~= "npc" then return end
	if not LocalPlayer():IsSuperAdmin() then return end

	local class = icon:GetSpawnName()

	local hpMenu, hpParent = dMenu:AddSubMenu("#mcs.ui.set_class_health")
	MCS.ShowHealthMenu(class, hpMenu)
	hpParent:SetIcon("icon16/heart.png")

	local apMenu, apParent = dMenu:AddSubMenu("#mcs.ui.set_class_armor")
	MCS.ShowArmorMenu(class, apMenu)
	apParent:SetIcon("icon16/shield.png")

	local augMenu, augParent = dMenu:AddSubMenu("#mcs.ui.set_class_augment")
	MCS.ShowAugmentMenu(class, augMenu)
	augParent:SetIcon("icon16/gun.png")
end)