
local HealthSelImg
local ArmorSelImg
local HealthSel
local ArmorSel

local AugmentDict = {}
local AugmentSelImg
--local AugmentSel

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
		newButton:SetMaterial(MCS.GetIconMaterial(_type, "icons/armor/unarmored.png"))
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
	Header:SetTall(30)
	Header:SetFont("CreditsText")
	Header:SetContentAlignment(5)
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

local update = {}

spawnmenu.AddCreationTab("#mcs.material_combat_system", function()
	local NewFrame = vgui.Create("Panel")
	-- It appears the Panel acts as though set to Dock FILL in the tab window, which is good because otherwise sizing things would be messy.
	-- ^^ https://github.com/Facepunch/garrysmod/blob/2303e61a5ea696dba22140cdda0549bb6a1a2487/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu.lua#L50

	-- Health and Armor selection container
	local LeftZone = vgui.Create("Panel", NewFrame)
	LeftZone:Dock(LEFT)
	LeftZone:SetWide(ScreenScale(160)) -- 1/4 screen width

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
	local ButtonZone = vgui.Create("Panel", LeftZone)
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

	makeRadarPanel(ArmorSection2, "#mcs.ui.armor_drain_rate", Color(128, 128, 255), "MCS_SelectedArmor", "DrainRate")

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

	-- Augment page, largely unfinished.
	local AugmentPanel = vgui.Create("Panel", InfoSheets)
	InfoSheets:AddSheet("#mcs.ui.augments", AugmentPanel, "icon16/gun.png")

	local WeaponListPanel = vgui.Create("Panel", AugmentPanel)
	WeaponListPanel:SetHeight(ScreenScale(120))
	WeaponListPanel:Dock(TOP)

	local WeaponScrollPanel = vgui.Create("DScrollPanel", WeaponListPanel)
	WeaponScrollPanel:Dock(FILL)

	-- TODO: Why is this not working? additional weapons do not wrap??
	local WeaponGrid = vgui.Create("DIconLayout", WeaponScrollPanel)
	WeaponGrid:Dock(FILL)
	WeaponGrid:SetSpaceX(8)
	WeaponGrid:SetSpaceY(8)
	WeaponGrid:SetBorder(8)

	local DamageListPanel = vgui.Create("Panel", AugmentPanel)
	DamageListPanel:Dock(FILL)

	local DamageGrid = vgui.Create("DIconLayout", DamageListPanel)
	DamageGrid:Dock(FILL)
	-- TODO: Add all damage types available to augment weapons with into the DamageGrid, apply to AugmentSel when pressed.

	-- Add new weapons to the dictionary, making an icon in WeaponGrid for each.
	hook.Add("SpawnMenuOpen", "SpawnMenuWhitelist", function()
		local CurrentWeapons = LocalPlayer():GetWeapons()
		for I = 1, #CurrentWeapons do
			if AugmentDict[CurrentWeapons[I]:GetClass()] then continue end

			AugmentDict[CurrentWeapons[I]:GetClass()] = "none"

			local NewButton = vgui.Create("DButton")
			NewButton:SetSize(80, 80)
			NewButton:SetText(CurrentWeapons[I]:GetPrintName())
			NewButton.DoClick = function()
				AugmentSel = CurrentWeapons[I]:GetClass()
				if AugmentSelImg then AugmentSelImg:Remove() end
				AugmentSelImg = addSelIndicator(NewButton, false)
			end

			WeaponGrid:Add(NewButton)
		end
	end)

	return NewFrame
end, "icon16/heart.png", 2000)

hook.Add("SpawnMenuOpen", "MCS_OpenMenu", function()
	for _, v in ipairs(update) do
		v()
	end
end)