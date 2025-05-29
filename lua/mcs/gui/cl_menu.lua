function addButtonRow(tbl, frame, height, isHealth)
	local newDivider = vgui.Create("DVerticalDivider", frame)
	newDivider:SetPos(0, height)

	local i = 0
	for id, _type in pairs(tbl) do
		local name = MCS.L(string.format("mcs.%s.%s.name", _type.Set, id))

		local newButton = vgui.Create("DImageButton", frame)
		newButton:SetImage(_type.Icon)
		newButton:SetSize(60, 60)
		newButton:SetPos(60 * i, height)
		newButton:SetTooltip(_type.Set .. ": " .. name) -- not localized properly
		newButton.DoClick = function()
			local pass, message
			if isHealth then
				pass, message = LocalPlayer():MCS_SetHealthType(id)
			else
				pass, message = LocalPlayer():MCS_SetArmorType(id)
			end

			if pass then
				LocalPlayer():ChatPrint("selected " .. name) -- not localized properly
				surface.PlaySound("buttons/button14.wav")
			else
				LocalPlayer():MCS_Notify(message)
				surface.PlaySound("buttons/button10.wav")
			end
		end

		i = i + 1
	end
end

spawnmenu.AddCreationTab("#mcs.mcs", function()
	local newFrame = vgui.Create("DPanel")

	-- Iterate through all healths and add buttons for them
	addButtonRow(MCS.GetHealthTypes(), newFrame, 20, true)
	addButtonRow(MCS.GetArmorTypes(), newFrame, 120, false)

	return newFrame
end, "icon16/heart.png", 18)