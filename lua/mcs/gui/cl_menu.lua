
local HealthSelImg
local ArmorSelImg
local HealthSel
local ArmorSel

--[[
This function creates an image which is overlaid over the client's selected armor & health types.
The image is yellow initially, but both should be turned green on successful application.
]]--
local function addSelIndicator(frame, isCircle)
	local NewImage = vgui.Create("DImage", frame)

	if isCircle then
		NewImage:SetImage("ui/selection.png")
	else
		NewImage:SetImage("ui/selectionsq.png")
	end

	NewImage:Dock(FILL)
	NewImage:SetImageColor(Color(255, 255, 20))

	return NewImage
end

--[[
This function adds buttons to a DIconLayout according to a table of health/armor types
]]--
local function addButtonRow(tbl, frame, isHealth)
	for id, _type in pairs(tbl) do
		local name = MCS.L(string.format("mcs.%s.%s.name", _type.Set, id))
		local newButton = vgui.Create("DImageButton")

		frame:Add(newButton)
		newButton:SetMaterial(MCS.GetIconMaterial(_type))
		newButton.m_Image:SetImageColor(_type.Color or color_white)
		newButton:SetSize(80, 80)
		newButton:SetTooltip(name)
		newButton:SetTooltipDelay(0)
		newButton.DoClick = function()
			-- TODO: On selection, update HealthInfo and ArmorInfo to show descriptions for each
			-- TODO: On selection, update HealthRadar and ArmorRadar
			if isHealth then
				if HealthSel == id then return end

				HealthSel = id
				if HealthSelImg then
					HealthSelImg:Remove()
				end

				HealthSelImg = addSelIndicator(newButton, true)

				hook.Run("MCS_SelectedHealth", MCS.HealthType(id))
			else
				if ArmorSel == id then return end

				ArmorSel = id
				if ArmorSelImg then
					ArmorSelImg:Remove()
				end

				ArmorSelImg = addSelIndicator(newButton, true)

				hook.Run("MCS_SelectedArmor", MCS.ArmorType(id))
			end
		end
	end
end

--[[
This function is used to add standalone titles/labels to DIconLayouts
]]--
local dark = Color(0, 0, 0, 200)
local function addLabel(name, frame)
	local NewLabel = vgui.Create("DLabel", frame)
	NewLabel:SetText(name)
	NewLabel:SetColor(color_white)
	NewLabel:SetSize(320, 40)
	NewLabel:SetFont("CloseCaption_Bold")
	NewLabel:SetExpensiveShadow(2, dark)
	NewLabel.OwnLine = true -- Magic undocumented variable that lets it have it's own line

	return NewLabel
end

--[[
This function is used to add text entries to the settings zone
]]--
local function addTextEntry(name, frame, onUnfocus)
	local NewFrame = vgui.Create("Panel")
	NewFrame:SetTall(20)

	local NewLabel = vgui.Create("DLabel", NewFrame)
	NewLabel:SetText(name)
	NewLabel:SetColor(color_white)
	NewLabel:SizeToContents()
	NewLabel:Dock(LEFT)

	local NewEntry = vgui.Create("DTextEntry", NewFrame)
	NewEntry:SetWide(90)
	NewEntry:SetNumeric(true)
	NewEntry:Dock(RIGHT)

	NewFrame:SetWide(NewLabel:GetWide() + 95)

	frame:Add(NewFrame)

	return NewEntry
end

--[[
This function makes all of the vgui elements to display a radar chart
]]--
local function makeRadarPanel(panel, label, color, hookName, member)
	local Header = vgui.Create("DLabel", panel)
	Header:SetText(label)
	Header:SetColor(color_white)
	Header:SetTall(40)
	Header:SetFont("CreditsText")
	Header:SetContentAlignment(5)
	Header:SetWrap(true)
	Header:Dock(TOP)

	local RadarHolder = vgui.Create("Panel", panel)
	RadarHolder:Dock(FILL)
	RadarHolder:DockMargin(0, 0, 0, 3)

	local RadarChart = vgui.Create("MCS_RadarChart", RadarHolder)
	local oldLayout = RadarChart.PerformLayout
	function RadarChart.PerformLayout(_, w, h)
		local size = math.min(RadarHolder:GetSize())
		RadarChart:SetSize(size, size)
		RadarChart:Center()

		oldLayout(RadarChart, w, h)
	end

	RadarChart:SetColor(color)

	hook.Add(hookName, label, function(_type)
		RadarChart:SetValues(_type[member])
	end)
end

local function makeAugmentMenu(panel, swep, printName)
	local ply = LocalPlayer()

	local _menu = DermaMenu()

	if ply.MCS_Augments[swep] ~= nil then
		local reset = _menu:AddOption("#mcs.none", function()
			local pass, message = ply:MCS_ClearAugment(swep)

			if pass then
				panel:SetText(printName)
				panel:SizeToContentsX(20)
				panel:SetEnabled(false)
				panel:SetTooltip()

				local parent = panel:GetParent()
				parent:Layout()
				parent:InvalidateLayout()
			else
				ply:MCS_Notify(message)
			end
		end)

		reset:SetMaterial("icon16/cross.png")
	end

	for id, dmgType in SortedPairsByMemberValue(MCS.GetDamageTypes(), "Order") do
		if dmgType.Hidden then continue end
		if not dmgType.AugmentDamage then continue end
		if ply.MCS_Augments[swep] == id then continue end

		local opt = _menu:AddOption(string.format("#mcs.damage.%s.name", id), function()
			local pass, message = ply:MCS_SetAugment(id, swep)

			if pass then
				panel:SetText(MCS.L(string.format("mcs.damage.%s.augment", id), printName))
				panel:SizeToContentsX(20)
				panel:SetEnabled(false)
				panel:SetTooltip(string.format("#mcs.damage.%s.name", id))

				local parent = panel:GetParent()
				parent:Layout()
				parent:InvalidateLayout()
			else
				ply:MCS_Notify(message)
			end
		end)

		opt:SetMaterial(MCS.GetIconMaterial(dmgType))
		opt.m_Image:SetImageColor(dmgType.Color or color_white)
	end

	_menu:Open()
end

local function makeNPCMenu(panel, spawnName)
	local _menu = DermaMenu()
	MCS.ShowNPCMenus(spawnName, _menu)
	_menu:Open()
end

local function drawNPCButton(panel, spawnName, w, h)
	local data = MCS.GetNPCData(spawnName)

	if data[1] then
		local healthType = MCS.HealthType(data[1])
		if healthType then
			surface.SetMaterial(MCS.GetIconMaterial(healthType))

			local color = healthType.Color or color_white
			surface.SetDrawColor(color:Unpack())

			surface.DrawTexturedRect(2, 2, 16, 16)
		end
	end

	if data[2] then
		local armorType = MCS.ArmorType(data[2])
		if armorType then
			surface.SetMaterial(MCS.GetIconMaterial(armorType))

			local color = armorType.Color or color_white
			surface.SetDrawColor(color:Unpack())

			surface.DrawTexturedRect(w - 18, 2, 16, 16)
		end
	end

	if data[3] then
		local dmgType = MCS.DamageType(data[3])
		if dmgType then
			surface.SetMaterial(MCS.GetIconMaterial(dmgType))

			local color = dmgType.Color or color_white
			surface.SetDrawColor(color:Unpack())

			surface.DrawTexturedRect(w - 18, h - 18, 16, 16)
		end
	end
end

local update = {}

spawnmenu.AddCreationTab("#mcs.material_combat_system", function()
	update = {}

	local NewFrame = vgui.Create("Panel")
	-- It appears the Panel acts as though set to Dock FILL in the tab window, which is good because otherwise sizing things would be messy.
	-- ^^ https://github.com/Facepunch/garrysmod/blob/2303e61a5ea696dba22140cdda0549bb6a1a2487/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu.lua#L50

	-- Health and Armor selection container
	local LeftZone = vgui.Create("Panel", NewFrame)
	LeftZone:Dock(LEFT)

	function LeftZone.PerformLayout()
		LeftZone:SetWide(ScreenScale(160)) -- 1/4 screen width
	end

	local ScrollZone = vgui.Create("DScrollPanel", LeftZone)
	ScrollZone:Dock(FILL)

	local IconList = vgui.Create("DIconLayout", ScrollZone)
	IconList:Dock(FILL)
	IconList:SetSpaceX(8)
	IconList:SetSpaceY(8)
	IconList:SetBorder(16)

	addLabel("#mcs.ui.health", IconList)
	addButtonRow(MCS.GetHealthTypes(), IconList, true)

	addLabel("#mcs.ui.armor", IconList)
	addButtonRow(MCS.GetArmorTypes(), IconList, false)

	-- Settings container
	local SettingsZone = vgui.Create("Panel", NewFrame)
	SettingsZone:Dock(TOP)
	SettingsZone:SetTall(80)

	local SettingsGrid = vgui.Create("DIconLayout", SettingsZone)
	SettingsGrid:Dock(FILL)
	SettingsGrid:SetSpaceX(8)
	SettingsGrid:SetSpaceY(8)
	SettingsGrid:SetBorder(16)

	addLabel("#mcs.ui.settings", SettingsGrid)

	local MaxHpEntry = addTextEntry("#mcs.ui.set_max_health", SettingsGrid)
	MaxHpEntry.OnLoseFocus = function()
		hook.Call("OnTextEntryLoseFocus", nil, MaxHpEntry)

		local hp = tonumber(MaxHpEntry:GetText())
		if not hp then return end

		MCS.SetMax(hp)
	end

	table.insert(update, function()
		if not IsValid(MaxHpEntry) then return end
		MaxHpEntry:SetText(LocalPlayer():GetMaxHealth())
	end)

	local MaxArmorEntry = addTextEntry("#mcs.ui.set_max_armor", SettingsGrid)
	MaxArmorEntry.OnLoseFocus = function()
		hook.Call("OnTextEntryLoseFocus", nil, MaxArmorEntry)

		local ap = tonumber(MaxArmorEntry:GetText())
		if not ap then return end

		MCS.SetMax(ap, true)
	end

	table.insert(update, function()
		if not IsValid(MaxArmorEntry) then return end
		MaxArmorEntry:SetText(LocalPlayer():GetMaxArmor())
	end)

	-- Equip button container
	local ButtonZone = vgui.Create("Panel", NewFrame)
	ButtonZone:Dock(BOTTOM)
	ButtonZone:DockPadding(8, 8, 8, 8)
	ButtonZone:SetHeight(60)

	local EquipButton = vgui.Create("DButton", ButtonZone)
	EquipButton:Dock(RIGHT)
	EquipButton:SetText("#mcs.ui.equip_health_armor")
	EquipButton:SetSize(180, 60)
	EquipButton.DoClick = function()
		-- MSC_SetHealthType and MCS_SetArmorType do not pass false if rejected for having already chosen
		local passH, messageH = LocalPlayer():MCS_SetHealthType(HealthSel)
		local passA, messageA = LocalPlayer():MCS_SetArmorType(ArmorSel)

		if not HealthSelImg or not ArmorSelImg then return end

		-- TODO: Tell the player in chat what they selected.
		if not passH then
			LocalPlayer():MCS_Notify(messageH)
			HealthSelImg:SetImageColor(Color(255, 20, 20))
		elseif IsValid(HealthSelImg) then
			HealthSelImg:SetImageColor(Color(20, 255, 20))
		end
		if not passA then
			LocalPlayer():MCS_Notify(messageA)
			ArmorSelImg:SetImageColor(Color(255, 20, 20))
		elseif IsValid(ArmorSelImg) then
			ArmorSelImg:SetImageColor(Color(20, 255, 20))
		end

		if passH and passA then
			surface.PlaySound("buttons/button14.wav")
		else
			surface.PlaySound("buttons/button10.wav")
		end
	end

	-- Information zone container
	local InfoZone = vgui.Create("Panel", NewFrame)
	InfoZone:Dock(FILL)
	InfoZone:DockPadding(8, 16, 8, 8)

	local InfoSheets = vgui.Create("DPropertySheet", InfoZone)
	InfoSheets:Dock(FILL)

	-- Health and armor page
	local HAPanel = vgui.Create("Panel", InfoSheets)
	InfoSheets:AddSheet("#mcs.ui.health_armor", HAPanel, "icon16/heart.png")

	local RadarPanel = vgui.Create("Panel", HAPanel)
	RadarPanel:SetHeight(240)
	RadarPanel:Dock(TOP)

	local HealthSection = vgui.Create("Panel", RadarPanel)
	HealthSection:Dock(LEFT)
	function HealthSection.PerformLayout(panel)
		panel:SetWide(RadarPanel:GetWide() / 3)
	end

	makeRadarPanel(HealthSection, "#mcs.ui.health_dmg_mult", Color(255, 128, 128), "MCS_SelectedHealth", "DamageMultipliers")

	local ArmorSection1 = vgui.Create("Panel", RadarPanel)
	ArmorSection1:Dock(LEFT)
	ArmorSection1.PerformLayout = HealthSection.PerformLayout

	makeRadarPanel(ArmorSection1, "#mcs.ui.armor_dmg_mult", Color(192, 96, 255), "MCS_SelectedArmor", "DamageMultipliers")

	local ArmorSection2 = vgui.Create("Panel", RadarPanel)
	ArmorSection2:Dock(FILL)

	makeRadarPanel(ArmorSection2, "#mcs.ui.armor_drain_rate", Color(128, 128, 255), "MCS_SelectedArmor", "DrainRates")

	function RadarPanel.PerformLayout()
		HealthSection:InvalidateChildren(true)
		ArmorSection1:InvalidateChildren(true)
		ArmorSection2:InvalidateChildren(true)
	end

	local HealthLabel = addLabel("#mcs.ui.health", HAPanel)
	HealthLabel:Dock(TOP)

	local HealthInfo = vgui.Create("DLabel", HAPanel)
	HealthInfo:Dock(TOP)
	HealthInfo:SetText("#mcs.ui.health_select_to_read")
	HealthInfo:SetColor(color_white)
	HealthInfo:SetFont("CreditsText")
	HealthInfo:SetWrap(true)
	HealthInfo:SetAutoStretchVertical(true)

	hook.Add("MCS_SelectedHealth", "MCS_SetHealthInfo", function(_type)
		HealthLabel:SetColor(_type.Color or color_white)
		HealthLabel:SetText(string.format("#mcs.health.%s.name", _type.ID))
		HealthInfo:SetText(string.format("#mcs.health.%s.desc", _type.ID))
	end)

	local ArmorLabel = addLabel("#mcs.ui.armor", HAPanel)
	ArmorLabel:Dock(TOP)

	local ArmorInfo = vgui.Create("DLabel", HAPanel)
	ArmorInfo:Dock(TOP)
	ArmorInfo:SetText("#mcs.ui.armor_select_to_read")
	ArmorInfo:SetColor(color_white)
	ArmorInfo:SetFont("CreditsText")
	ArmorInfo:SetWrap(true)
	ArmorInfo:SetAutoStretchVertical(true)

	hook.Add("MCS_SelectedArmor", "MCS_SetArmorInfo", function(_type)
		ArmorLabel:SetColor(_type.Color or color_white)
		ArmorLabel:SetText(string.format("#mcs.armor.%s.name", _type.ID))
		ArmorInfo:SetText(string.format("#mcs.armor.%s.desc", _type.ID))
	end)

	local AugmentPanel = vgui.Create("Panel", InfoSheets)
	InfoSheets:AddSheet("#mcs.ui.augments", AugmentPanel, "icon16/gun.png")

	local WeaponScrollPanel = vgui.Create("DScrollPanel", AugmentPanel)
	WeaponScrollPanel:Dock(FILL)

	local WeaponGrid = vgui.Create("DIconLayout", WeaponScrollPanel)
	WeaponGrid:Dock(TOP)
	WeaponGrid:SetSpaceX(8)
	WeaponGrid:SetSpaceY(8)
	WeaponGrid:SetBorder(8)
	WeaponGrid:SetStretchHeight(true)
	WeaponGrid.Weapons = {}

	-- Add new weapons to the dictionary, making an icon in WeaponGrid for each.
	table.insert(update, function()
		if not IsValid(WeaponGrid) then return end

		local ply = LocalPlayer()

		ply.MCS_HasSetAugments = ply.MCS_HasSetAugments or {}
		ply.MCS_Augments = ply.MCS_Augments or {}

		for swep, panel in pairs(WeaponGrid.Weapons) do
			if not ply:HasWeapon(swep) then
				panel:Remove()
			end
		end

		for _, swepEnt in ipairs(ply:GetWeapons()) do
			local swep = swepEnt:GetClass()
			local printName = swepEnt:GetPrintName()

			local NewButton
			if WeaponGrid.Weapons[swep] then
				NewButton = WeaponGrid.Weapons[swep]
			end

			if not IsValid(NewButton) then
				NewButton = vgui.Create("DButton")
				NewButton:SetSize(120, 40)

				function NewButton.PaintOver(_, w, h)
					local dmgID = ply.MCS_Augments[swep]
					if not dmgID then return end

					local dmgType = MCS.DamageType(dmgID)
					if not dmgType then return end

					surface.SetDrawColor(dmgType.Color or color_white)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

				WeaponGrid:Add(NewButton)
				WeaponGrid.Weapons[swep] = NewButton
			end

			if ply.MCS_Augments[swep] then
				NewButton:SetText(MCS.L(string.format("mcs.damage.%s.augment", ply.MCS_Augments[swep]), swepEnt:GetPrintName()))
				NewButton:SetTooltip(string.format("#mcs.damage.%s.name", ply.MCS_Augments[swep]))
			else
				NewButton:SetText(printName)
				NewButton:SetTooltip()
			end

			function NewButton.DoClick()
				makeAugmentMenu(NewButton, swep, printName)
			end
			NewButton.DoRightClick = NewButton.DoClick

			NewButton:SizeToContentsX(20)
			NewButton:SetEnabled(not ply.MCS_HasSetAugments[swep])
		end

		WeaponGrid:Layout()
		WeaponGrid:InvalidateLayout()
	end)

	local NPCPanel = vgui.Create("Panel", InfoSheets)

	local NPCEntryPanel = vgui.Create("Panel", NPCPanel)
	NPCEntryPanel:Dock(TOP)
	NPCEntryPanel:SetTall(58)
	NPCEntryPanel:DockPadding(8, 8, 8, 12)

	local NPCEntry = vgui.Create("DTextEntry", NPCEntryPanel)
	NPCEntry:Dock(LEFT)
	NPCEntry:DockMargin(0, 0, 8, 0)
	NPCEntry:SetWide(250)
	NPCEntry:SetUpdateOnType(true)
	NPCEntry:SetPlaceholderText("#mcs.ui.class_or_spawn_name")

	local NPCButton = vgui.Create("DButton", NPCEntryPanel)
	NPCButton:Dock(LEFT)
	NPCButton:SetText("#mcs.ui.set_npc_data")
	NPCButton:SizeToContentsX(30)
	NPCButton:SetEnabled(false)

	function NPCButton.DoClick()
		local text = string.Trim(NPCEntry:GetText())
		if text == "" then return end

		makeNPCMenu(NPCButton, text)
	end
	NPCButton.DoRightClick = NPCButton.DoClick

	function NPCButton.PaintOver(_, w, h)
		local text = string.Trim(NPCEntry:GetText())
		if text == "" then return end

		drawNPCButton(NPCButton, text, w, h)
	end

	function NPCEntry.OnValueChange(_, value)
		NPCButton:SetEnabled(string.Trim(value) ~= "")
	end

	local NPCScrollPanel = vgui.Create("DScrollPanel", NPCPanel)
	NPCScrollPanel:Dock(FILL)

	local NPCGrid = vgui.Create("DIconLayout", NPCScrollPanel)
	NPCGrid:Dock(TOP)
	NPCGrid:SetSpaceX(8)
	NPCGrid:SetSpaceY(8)
	NPCGrid:SetBorder(8)
	NPCGrid:SetStretchHeight(true)
	NPCGrid.NPCs = {}

	table.insert(update, function()
		if not IsValid(NPCGrid) then return end
		if not LocalPlayer():IsSuperAdmin() then return end

		for spawnName, panel in pairs(NPCGrid.NPCs) do
			if not MCS.NPCData[spawnName] then
				panel:Remove()
			end
		end

		for spawnName, data in pairs(MCS.NPCData) do
			local NewButton
			if NPCGrid.NPCs[spawnName] then
				NewButton = NPCGrid.NPCs[spawnName]
			end

			if not IsValid(NewButton) then
				NewButton = vgui.Create("DButton")
				NewButton:SetSize(120, 40)
				NewButton:SetText(spawnName)
				NewButton:SizeToContentsX(30)

				function NewButton.PaintOver(_, w, h)
					drawNPCButton(NewButton, spawnName, w, h)
				end

				NPCGrid:Add(NewButton)
				NPCGrid.NPCs[spawnName] = NewButton
			end

			function NewButton.DoClick()
				makeNPCMenu(NewButton, spawnName)
			end
			NewButton.DoRightClick = NewButton.DoClick
		end
	end)

	local function doNPCPanel()
		if not IsValid(NPCPanel) then return end

		if LocalPlayer():IsSuperAdmin() then
			if NPCPanel.Tab then return end

			NPCPanel:Show()
			NPCPanel.Tab = InfoSheets:AddSheet("#mcs.ui.npcs", NPCPanel, "icon16/monkey.png").Tab
		else
			NPCPanel:Hide()

			if not NPCPanel.Tab then return end

			InfoSheets:CloseTab(NPCPanel.Tab, false)
			NPCPanel.Tab = nil
		end
	end

	table.insert(update, doNPCPanel)

	return NewFrame
end, "icon16/heart.png", 2000)

hook.Add("SpawnMenuOpen", "MCS_OpenMenu", function()
	for _, v in ipairs(update) do
		v()
	end
end)