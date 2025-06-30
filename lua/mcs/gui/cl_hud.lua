local enabledCvar = CreateClientConVar("mcs_hud_enabled", 1, true, true, "Whether the MCS hud is enabled (0 = false, 1 = let server decide, 2 = true).", 0, 2)
local healthArmorCvar = CreateClientConVar("mcs_hud_show_health_armor", 1, true, true, "Whether the MCS hus shows health and armor (0 = false, 1 = let server decide, 2 = true).", 0, 2)
local xPosCvar = CreateClientConVar("mcs_hud_pos_x", 0.374522, true, true, "The horizontal position of the MCS hud.", 0, 1)
local yPosCvar = CreateClientConVar("mcs_hud_pos_y", 0.984000, true, true, "The vertical position of the MCS hud.", 0, 1)

local enabledMat = Material("icon16/photo_delete.png")
local disabledMat = Material("icon16/photo_add.png")
local haEnabledMat = Material("icon16/heart_delete.png")
local haDisabledMat = Material("icon16/heart_add.png")

local vector_one = Vector(1, 1, 1)

surface.CreateFont("MCSHud", {
	font = "Arial",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	outline = true,
})

local effectData = {}

local PANEL = {}

function PANEL:Init()
	self:SetSize(350, 80)
	self:SetCursor("sizeall")
	self:SetZPos(-1)
	self:FixPosition()
	self:NoClipping(true)
	self:SetTooltip("#mcs.ui.mcs_hud")

	self.SEnabledCvar = GetConVar("mcs_sv_hud_enable_by_default")
	self.SHealthArmorCvar = GetConVar("mcs_sv_hud_show_health_armor_by_default")

	typeDisplay = self:Add("Panel")
	self.TypeDisplay = typeDisplay

	typeDisplay:Dock(xPosCvar:GetFloat() > 0.75 and RIGHT or LEFT)
	typeDisplay:SetMouseInputEnabled(false)

	function typeDisplay.Paint(_, w, h)
		if self:ShouldBeHidden() and not self.InContextMenu then return end

		local ply = LocalPlayer()
		local healthType = ply:MCS_GetHealthType()
		local armorType = ply:MCS_GetArmorType()
		if not healthType or not armorType then return end

		self:DrawHealthType(healthType, w, h)
		self:DrawArmorType(armorType, w, h)

		local armorText = ""
		if not armorType.HideOnHud then
			aC = armorType.Color or color_white
			armorText = string.format("\n<color=%s,%s,%s>%s</color>", aC.r, aC.g, aC.b, MCS.L(string.format("mcs.armor.%s.abbr", armorType.ID)))
		end

		local hC = healthType.Color or color_white
		local parsed = markup.Parse(string.format("<font=MCSHud><color=%s,%s,%s>%s</color>%s</font>", hC.r, hC.g, hC.b, MCS.L(string.format("mcs.health.%s.abbr", healthType.ID)), armorText))
		parsed:Draw(h - 2, 4, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local newW = h + parsed:GetWidth() + 2
		if newW ~= w then
			typeDisplay:SetWide(newW)
		end
	end

	statusDisplay = self:Add("Panel")
	self.StatusDisplay = statusDisplay

	function statusDisplay.Paint(_, w, h)
		if self:ShouldBeHidden() and not self.InContextMenu then return end

		local effectList = LocalPlayer():MCS_GetEffects()
		if table.IsEmpty(effectList) then
			if not self.InContextMenu then return end

			surface.SetDrawColor(192, 192, 192)
			draw.SimpleText(MCS.L("mcs.ui.no_effects"), "MCSHud", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		local goRight = xPosCvar:GetFloat() > 0.75
		local goDown = yPosCvar:GetFloat() < 0.75

		local clipping = DisableClipping(true)
		local y = goDown and 2 or h - 2
		for id, data in pairs(effectList) do
			local countStr = data.count > 1 and string.format("%s x ", data.count) or ""
			local text = string.format("%s%s", countStr, MCS.L(string.format("mcs.effect.%s.name", id)))

			local effect = MCS.EffectType(id)
			local color = effect.Color or color_white

			surface.SetDrawColor(color:Unpack())
			surface.SetMaterial(MCS.GetIconMaterial(effect))

			if goDown then
				if goRight then
					surface.DrawTexturedRect(w - 18, y + 2, 16, 16)
					statusDisplay.EffectText(id, data, text, w - 24, y + 1, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				else
					surface.DrawTexturedRect(2, y + 2, 16, 16)
					statusDisplay.EffectText(id, data, text, 24, y + 1, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				end

				y = y + 20
			else
				if goRight then
					surface.DrawTexturedRect(w - 18, y - 18, 16, 16)
					statusDisplay.EffectText(id, data, text, w - 24, y + 1, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				else
					surface.DrawTexturedRect(2, y - 18, 16, 16)
					statusDisplay.EffectText(id, data, text, 24, y + 1, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				end

				y = y - 20
			end
		end
		DisableClipping(clipping)
	end

	function statusDisplay.EffectText(id, data, text, x, y, color, alignH, alignV)
		effectData[id] = effectData[id] or {}
		local eData = effectData[id]

		eData.textScale = eData.textScale or 1.25
		eData.procID = eData.procID or data.procID

		if not eData.lastCount or eData.lastCount <= eData.count then
			eData.lastCount = eData.count

			if eData.lastCount == eData.count and eData.procID ~= data.procID then
				eData.textScale = 1.25
				eData.procID = data.procID
			end
		else
			eData.textScale = 1.25
		end

		surface.SetFont("MCSHud")
		local x1, y1 = statusDisplay:LocalToScreen(0, 0)
		local xAdd, yAdd = 0, 0
		local w, h = surface.GetTextSize(text)

		if alignH == TEXT_ALIGN_LEFT then
			xAdd = w / 2
		elseif alignH == TEXT_ALIGN_RIGHT then
			xAdd = -w / 2
		end

		if alignV == TEXT_ALIGN_TOP then
			yAdd = h / 2
		elseif alignV == TEXT_ALIGN_BOTTOM then
			yAdd = -h / 2
		end

		local pos = Vector(x1 + x + xAdd, y1 + y + yAdd, 0)

		local m = Matrix()
		m:Translate(pos)
		m:Scale(vector_one * eData.textScale)
		m:Translate(-pos)

		cam.PushModelMatrix(m, true)
		draw.SimpleText(text, "MCSHud", x + xAdd, y + yAdd, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.PopModelMatrix()

		eData.textScale = MCS.Dampen(10, eData.textScale, 1)
	end

	statusDisplay:Dock(FILL)
	statusDisplay:SetMouseInputEnabled(false)

	hBtn = self:Add("DButton")
	self.HideButton = hBtn

	hBtn:SetSize(20, 20)
	hBtn:InvalidateLayout()
	hBtn:SetText("")
	hBtn:SetTooltip(self:ShouldBeHidden() and "#mcs.ui.show_hud" or "#mcs.ui.hide_hud")

	function hBtn.PerformLayout()
		hBtn:AlignTop()
		hBtn:AlignRight()
	end

	function hBtn.Paint(_, w, h)
		if hBtn:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 20)
			surface.DrawRect(0, 0, w, h)
		end

		if self:ShouldBeHidden() then
			surface.SetMaterial(disabledMat)
		else
			surface.SetMaterial(enabledMat)
		end

		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(2, 2, 16, 16)
	end

	function hBtn.DoClick()
		local state = self:ShouldBeHidden()

		if state then
			RunConsoleCommand("mcs_hud_enabled", "2")
		else
			RunConsoleCommand("mcs_hud_enabled", "0")
		end

		timer.Simple(0, function()
			if not hBtn:IsValid() then return end
			hBtn:SetTooltip(self:ShouldBeHidden() and "#mcs.ui.show_hud" or "#mcs.ui.hide_hud")
		end)
	end

	if not self.InContextMenu then
		hBtn:Hide()
	end

	haBtn = self:Add("DButton")
	self.HealthArmorButton = haBtn

	haBtn:SetSize(20, 20)
	haBtn:InvalidateLayout()
	haBtn:SetText("")
	haBtn:SetTooltip(self:HAShouldBeHidden() and "#mcs.ui.mcs_hud_show_health_armor" or "#mcs.ui.mcs_hud_show_health_armor")

	function haBtn.PerformLayout()
		haBtn:AlignTop()
		haBtn:AlignRight(20)
	end

	function haBtn.Paint(_, w, h)
		if haBtn:IsHovered() then
			surface.SetDrawColor(255, 255, 255, 20)
			surface.DrawRect(0, 0, w, h)
		end

		if self:HAShouldBeHidden() then
			surface.SetMaterial(haDisabledMat)
		else
			surface.SetMaterial(haEnabledMat)
		end

		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(2, 2, 16, 16)
	end

	function haBtn.DoClick()
		local state = self:HAShouldBeHidden()

		if state then
			RunConsoleCommand("mcs_hud_show_health_armor", "2")
		else
			RunConsoleCommand("mcs_hud_show_health_armor", "0")
		end

		timer.Simple(0, function()
			if not haBtn:IsValid() then return end
			haBtn:SetTooltip(self:HAShouldBeHidden() and "#mcs.ui.show_health_armor" or "#mcs.ui.hide_health_armor")
		end)
	end

	if not self.InContextMenu then
		haBtn:Hide()
	end

	hook.Add("OnScreenSizeChanged", self, self.FixPosition)
	hook.Add("ContextMenuOpened", self, self.ContextMenuOpened)
	hook.Add("ContextMenuClosed", self, self.ContextMenuClosed)
end

function PANEL:HAShouldBeHidden()
	local enabledInt = healthArmorCvar:GetInt()
	return enabledInt < 1 or enabledInt == 1 and not self.SHealthArmorCvar:GetBool()
end

function PANEL:ShouldBeHidden()
	local enabledInt = enabledCvar:GetInt()
	return enabledInt < 1 or enabledInt == 1 and not self.SEnabledCvar:GetBool()
end

function PANEL:FixPosition()
	local x = math.Clamp(xPosCvar:GetFloat(), 0, 1) * (ScrW() - self:GetWide())
	local y = math.Clamp(yPosCvar:GetFloat(), 0, 1) * (ScrH() - self:GetTall())

	self:SetPos(x, y)
end

function PANEL:ContextMenuOpened()
	self.InContextMenu = true
	self:SetParent(g_ContextMenu)

	self.HideButton:Show()
	self.HealthArmorButton:Show()
end

function PANEL:ContextMenuClosed()
	self.InContextMenu = nil
	self:SetParent(vgui.GetWorldPanel())

	self.HideButton:Hide()
	self.HealthArmorButton:Hide()
end

function PANEL:OnMousePressed()
	self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
	self:MouseCapture(true)
	self:SetZPos(100)
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self:MouseCapture(false)
	self:SetZPos(-1)

	local rX = self:GetX() / (ScrW() - self:GetWide())
	local rY = self:GetY() / (ScrH() - self:GetTall())

	if rX > 0.75 then
		self.TypeDisplay:Dock(RIGHT)
	else
		self.TypeDisplay:Dock(LEFT)
	end

	self:InvalidateLayout()

	xPosCvar:SetFloat(rX)
	yPosCvar:SetFloat(rY)
end

function PANEL:Think()
	local hideTypes = self:HAShouldBeHidden()
	if self.TypeDisplay:IsVisible() == hideTypes then
		self.TypeDisplay:SetVisible(not hideTypes)
		self:InvalidateLayout()
	end

	if not self.Dragging then return end

	local sw = ScrW() - self:GetWide()
	local sh = ScrH() - self:GetTall()

	local x = gui.MouseX() - self.Dragging[1]
	local y = gui.MouseY() - self.Dragging[2]

	if input.IsKeyDown(KEY_LSHIFT) then
		x = math.Round(x / (sw / 16)) * (sw / 16)
		y = math.Round(y / (sh / 16)) * (sh / 16)
	elseif input.IsKeyDown(KEY_LALT) then
		x = math.Round(x / (sw / 64)) * (sw / 64)
		y = math.Round(y / (sh / 64)) * (sh / 64)
	end

	self:SetPos(math.Clamp(x, 0, sw), math.Clamp(y, 0, sh))
end

function PANEL:DrawHealthType(healthType, w, h)
	local color = healthType.Color or color_white
	surface.SetDrawColor(color:Unpack())
	surface.SetMaterial(MCS.GetIconMaterial(healthType), "icons/armor/unarmored.png")

	local drawW = h - 8
	surface.DrawTexturedRect(4, 4, drawW, drawW)
end

function PANEL:DrawArmorType(armorType, w, h)
	if armorType.HideOnHud then return end

	local color = armorType.Color or color_white
	surface.SetDrawColor(color:Unpack())
	surface.SetMaterial(MCS.GetIconMaterial(armorType), "icons/armor/unarmored.png")

	local drawW = h / 2 - 8
	surface.DrawTexturedRect(h * 0.8, h / 2 + 4, drawW, drawW)
end

function PANEL:PaintOver(w, h)
	if not self.InContextMenu then return end

	if self:ShouldBeHidden() then
		surface.SetDrawColor(255, 0, 0)
	else
		surface.SetDrawColor(0, 128, 255)
	end

	surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("mcs_hud", PANEL, "Panel")

local mcsEnabled
local doDraw = GetConVar("cl_drawhud"):GetBool()
local cameraOut

local function hideHud()
	if not IsValid(MCS.Hud) then return end

	if cameraOut or not doDraw or not mcsEnabled then
		MCS.Hud:Hide()
	else
		MCS.Hud:Show()
	end
end

local function fixPos()
	if not IsValid(MCS.Hud) then return end
	MCS.Hud:FixPosition()
end

cvars.AddChangeCallback("mcs_hud_pos_x", fixPos, "MCS_HudFix")
cvars.AddChangeCallback("mcs_hud_pos_y", fixPos, "MCS_HudFix1")

cvars.AddChangeCallback("cl_drawhud", function(_, _, val)
	doDraw = val ~= "0"
	hideHud()
end, "MCS_HideHud1")

hook.Add("PlayerSwitchWeapon", "MCS_HideHud", function(_, _, newWeapon)
	cameraOut = newWeapon:GetClass() == "gmod_camera"
	hideHud()
end)

local function tick()
	if not IsValid(MCS.Hud) then return end

	local curEnabled = LocalPlayer():MCS_GetEnabled()
	if curEnabled ~= mcsEnabled then
		mcsEnabled = curEnabled
		hideHud()
	end
end

hook.Add("InitPostEntity", "MCS_MakeHud", function()
	MCS.Hud = vgui.Create("mcs_hud")
	hook.Add("Tick", "MCS_CheckMCSEnabled", tick)
end)

-- hotload support
if IsValid(MCS.Hud) then
	MCS.Hud:Remove()
	MCS.Hud = vgui.Create("mcs_hud")
	hook.Add("Tick", "MCS_CheckMCSEnabled", tick)
end