
local HealthSelImg
local ArmorSelImg
local HealthSel
local ArmorSel

local AugmentDict = {}
local AugmentSelImg
local AugmentSel

--[[
This function creates an image which is overlaid over the client's selected armor & health types.
The image is yellow initially, but both should be turned green on successful application.
]]--
function addSelIndicator(frame,isCircle)
	local NewImage = vgui.Create("DImage",frame)
		if isCircle then
		NewImage:SetImage("ui/selection.png")
		else
		NewImage:SetImage("ui/selectionsq.png")
		end
	NewImage:Dock( FILL )
	NewImage:SetImageColor(Color(255, 255, 20, 255))
	return NewImage
end

--[[
This function adds buttons to a DIconLayout according to a table of health/armor types
]]--

function addButtonRow(tbl, frame, isHealth)
	for id, _type in pairs(tbl) do
		local name = MCS.L(string.format("mcs.%s.%s.name", _type.Set, id))
		local newButton = vgui.Create("DImageButton")
		frame:Add(newButton)
		newButton:SetImage(_type.Icon)
		newButton:SetSize(80, 80)
		newButton:SetTooltip(_type.Set .. ": " .. name) -- not localized properly
		newButton.DoClick = function() 
		-- TODO: On selection, update HealthInfo and ArmorInfo to show descriptions for each
		-- TODO: On selection, update HealthRadar and ArmorRadar
			if isHealth then
				if HealthSel == id then return end
				HealthSel = id
				if HealthSelImg then HealthSelImg:Remove() end
				HealthSelImg = addSelIndicator(newButton,true)
			else
				if ArmorSel == id then return end
				ArmorSel = id
				if ArmorSelImg then ArmorSelImg:Remove() end
				ArmorSelImg = addSelIndicator(newButton,true)
			end
		end
	end
end

--[[
This function is used to add standalone titles/labels to DIconLayouts
]]--

function addLabel(name, frame)
	local NewLabel = vgui.Create("DLabel", frame)
	NewLabel:SetText(name)
	NewLabel:SetColor(Color(30,30,30))
	NewLabel:SetSize(320,40)
	NewLabel:SetFont("CloseCaption_Bold")
	NewLabel.OwnLine = true -- Magic undocumented variable that lets it have it's own line
end

--[[
This function is used to add text entries to the settings zone
]]--

function addTextEntry(name, frame, onUnfocus)
	local NewFrame = vgui.Create("DPanel")
	NewFrame:SetSize(180,20)
	
	local NewLabel = vgui.Create("DLabel",NewFrame)
	NewLabel:SetText(name)
	NewLabel:SetColor(Color(30,30,30))
	NewLabel:SetSize(90,20)
	NewLabel:Dock( LEFT )
	
	local NewEntry = vgui.Create("DTextEntry",NewFrame)
	NewEntry:SetSize(90,20)
	NewEntry:SetNumeric( true )
	NewEntry:SetPlaceholderText( "100" )
	NewEntry:Dock( RIGHT )

	frame:Add(NewFrame)
	
	return NewEntry
end

--[[
This function can be used to set the text in a RichText
]]--

function setRichText(frame,text)
	frame:SetText("")
	frame:InsertColorChange( 0, 0, 0, 255 )
	frame:AppendText(text)
end

spawnmenu.AddCreationTab("#mcs.mcs", function()
	local NewFrame = vgui.Create("DPanel")
	-- It appears the Panel acts as though set to Dock FILL in the tab window, which is good because otherwise sizing things would be messy.
	
	-- Health and Armor selection container
	local LeftZone = vgui.Create("DPanel",NewFrame)
	LeftZone:Dock( LEFT )
	LeftZone:SetWide(ScreenScale( 160 )) -- 1/4 screen width
	
	local ScrollZone = vgui.Create("DScrollPanel", LeftZone)
	ScrollZone:Dock( FILL )
	
	local IconList = vgui.Create("DIconLayout", ScrollZone)
	IconList:Dock( FILL )
	IconList:SetSpaceX( 8 )
	IconList:SetSpaceY( 8 )
	IconList:SetBorder( 16 )
	
	addLabel("Health",IconList) -- not localized properly
	addButtonRow(MCS.GetHealthTypes(), IconList, true)
	
	addLabel("Armor",IconList) -- not localized properly
	addButtonRow(MCS.GetArmorTypes(), IconList, false)

	-- Settings container
	local SettingsZone = vgui.Create("DPanel",NewFrame)
	SettingsZone:Dock( TOP )
	SettingsZone:SetHeight( 200 )
	
	local SettingsGrid = vgui.Create("DIconLayout",SettingsZone)
	SettingsGrid:Dock( FILL )
	SettingsGrid:SetSpaceX( 8 )
	SettingsGrid:SetSpaceY( 8 )
	SettingsGrid:SetBorder( 16 )
	
	addLabel("Settings",SettingsGrid) -- not localized properly
	
	local MaxHpEntry = addTextEntry(" Max Health:",SettingsGrid) -- not localized properly
		MaxHpEntry.OnLoseFocus = function()
			-- TODO: Tell the server this client wants their max health set to MaxHpEntry:GetInt()
			print("Max health to "..MaxHpEntry:GetInt())
			-- When Overriding OnLoseFocus, this function and hook call are nessecary.
			MaxHpEntry:UpdateConvarValue()
			hook.Call( "OnTextEntryLoseFocus", nil, MaxHpEntry )
		end
	
	local MaxArmorEntry = addTextEntry(" Max Armor:",SettingsGrid) -- not localized properly
		MaxArmorEntry.OnLoseFocus = function()
			-- TODO: Tell the server this client wants their max armor set to MaxArmorEntry:GetInt()
			print("Max armor to "..MaxArmorEntry:GetInt())

			MaxArmorEntry:UpdateConvarValue()
			hook.Call( "OnTextEntryLoseFocus", nil, MaxArmorEntry )
		end
	
	-- Equip button container
	local ButtonZone = vgui.Create("DPanel",NewFrame)
	ButtonZone:Dock( BOTTOM )
	ButtonZone:DockPadding(8,8,8,8)
	ButtonZone:SetHeight(60)
	
	local EquipButton = vgui.Create("DButton",ButtonZone)
	EquipButton:Dock( RIGHT )
	EquipButton:SetText("Equip Health & Armor")
	EquipButton:SetSize(180,60)
	EquipButton.DoClick = function()
			-- MSC_SetHealthType and MCS_SetArmorType do not pass false if rejected for having already chosen
			local passH, messageH = LocalPlayer():MCS_SetHealthType(HealthSel)
			local passA, messageA = LocalPlayer():MCS_SetArmorType(ArmorSel)
			
			if not HealthSelImg or not ArmorSelImg then
				return
			end
				
				-- TODO: Tell the player in chat what they selected.		
			if not passH then
				LocalPlayer():MCS_Notify(messageH)
				HealthSelImg:SetImageColor(Color(255, 20, 20, 255))
				else
				HealthSelImg:SetImageColor(Color(20, 255, 20, 255))
			end
			if not passA then
				LocalPlayer():MCS_Notify(messageA)
				ArmorSelImg:SetImageColor(Color(255, 20, 20, 255))
				else
				ArmorSelImg:SetImageColor(Color(20, 255, 20, 255))
			end
			
			if passH and passA then
				surface.PlaySound("buttons/button14.wav")
				else
				surface.PlaySound("buttons/button10.wav")
			end
		end
	
	
	-- Information zone container
	local InfoZone = vgui.Create("DPanel", NewFrame)
	InfoZone:Dock( FILL )
	InfoZone:DockPadding(8,16,8,8)
	
	local InfoSheets = vgui.Create("DPropertySheet", InfoZone)
	InfoSheets:Dock( FILL )
	
	-- Health page
	local HealthPanel = vgui.Create("DPanel", InfoSheets)
	InfoSheets:AddSheet("Health",HealthPanel,"icon16/heart.png") -- not localized properly
	
	local HealthRadarPanel = vgui.Create("DPanel",HealthPanel)
	HealthRadarPanel:SetHeight(ScreenScale( 120 ))
	HealthRadarPanel:Dock( TOP )
	
	local HealthRadar = vgui.Create("mcs_radarchart",HealthRadarPanel)
	HealthRadar:SetSize(ScreenScale( 120 ),ScreenScale( 120 ))
	HealthRadar:SetPos(ScreenScale( 60 ),0)
	
	local HealthInfoPanel = vgui.Create("DPanel",HealthPanel)
	HealthInfoPanel:Dock( FILL )
	HealthInfoPanel:DockPadding(8,4,8,4)
	
	local HealthInfo = vgui.Create("RichText",HealthInfoPanel)
	HealthInfo:Dock( FILL )
	HealthInfo:InsertColorChange( 0, 0, 0, 255 )
	setRichText(HealthInfo,"Select a Health type to see\ninformation about it.")
	
	-- Armor info page
	local ArmorPanel = vgui.Create("DPanel", InfoSheets)
	InfoSheets:AddSheet("Armor",ArmorPanel,"icon16/shield.png") -- not localized properly
	
	local ArmorRadarPanel = vgui.Create("DPanel",ArmorPanel)
	ArmorRadarPanel:SetHeight(ScreenScale( 120 ))
	ArmorRadarPanel:Dock( TOP )
	
	local ArmorRadar = vgui.Create("mcs_radarchart",ArmorRadarPanel)
	ArmorRadar:SetSize(ScreenScale( 120 ),ScreenScale( 120 ))
	ArmorRadar:SetPos(ScreenScale( 60 ),0)
	
	local ArmorInfoPanel = vgui.Create("DPanel",ArmorPanel)
	ArmorInfoPanel:Dock( FILL )
	ArmorInfoPanel:DockPadding(8,4,8,4)
	
	local ArmorInfo = vgui.Create("RichText",ArmorInfoPanel)
	ArmorInfo:Dock( FILL )
	setRichText(ArmorInfo,"Select an Armor type to see\ninformation about it.")
	
	-- Augment page, largely unfinished.
	local AugmentPanel = vgui.Create("DPanel", InfoSheets)
	InfoSheets:AddSheet("Augment",AugmentPanel,"icon16/gun.png") -- not localized properly
	
	local WeaponListPanel = vgui.Create("DPanel", AugmentPanel)
	WeaponListPanel:SetHeight(ScreenScale( 120 ))
	WeaponListPanel:Dock( TOP )
	
	local WeaponScrollPanel = vgui.Create("DScrollPanel",WeaponListPanel)
	WeaponScrollPanel:Dock( FILL )
	
	-- TODO: Why is this not working? additional weapons do not wrap??
	local WeaponGrid = vgui.Create("DIconLayout",WeaponScrollPanel)
	WeaponGrid:Dock( FILL )
	WeaponGrid:SetSpaceX( 8 )
	WeaponGrid:SetSpaceY( 8 )
	WeaponGrid:SetBorder( 8 )
	
	local DamageListPanel = vgui.Create("DPanel", AugmentPanel)
	DamageListPanel:Dock( FILL )
	
	local DamageGrid = vgui.Create("DIconLayout",DamageListPanel)
	DamageGrid:Dock( FILL )
	-- TODO: Add all damage types available to augment weapons with into the DamageGrid, apply to AugmentSel when pressed.
	
	-- Add new weapons to the dictionary, making an icon in WeaponGrid for each.
	hook.Add( "SpawnMenuOpen", "SpawnMenuWhitelist", function()
		local CurrentWeapons = LocalPlayer():GetWeapons()
		for I=1,#CurrentWeapons do
			if not AugmentDict[CurrentWeapons[I]:GetClass()] then
				AugmentDict[CurrentWeapons[I]:GetClass()] = "none"
				
				local NewButton = vgui.Create("DButton")
				NewButton:SetSize(80, 80)
				NewButton:SetText(CurrentWeapons[I]:GetPrintName())
				NewButton.DoClick = function()
					AugmentSel = CurrentWeapons[I]:GetClass()
					if AugmentSelImg then AugmentSelImg:Remove() end
					AugmentSelImg = addSelIndicator(NewButton,false)
				end

				
				WeaponGrid:Add(NewButton)
			end
		end
		
	end)
	

	return NewFrame
end, "icon16/heart.png", 18)