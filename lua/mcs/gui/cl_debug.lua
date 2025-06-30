hook.Add("HUDDrawTargetID", "MCS_EffectDraw", function()
	local tr = util.GetPlayerTrace(LocalPlayer())
	local trace = util.TraceLine(tr)
	if not trace.Hit then return false end
	if not trace.HitNonWorld then return false end

	local text = "ERROR"
	local font = "TargetID"

	if trace.Entity:IsPlayer() then
		text = trace.Entity:Nick()
	else
		return false
	end

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)

	local MouseX, MouseY = input.GetCursorPos()

	if MouseX == 0 and MouseY == 0 or not vgui.CursorVisible() then
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	local gm = gmod.GetGamemode()

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, 120))
	draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 50))
	draw.SimpleText(text, font, x, y, gm:GetTeamColor(trace.Entity))

	y = y + h + 5

	-- Draw the health
	text = trace.Entity:Health() .. "%"
	font = "TargetIDSmall"

	surface.SetFont(font)
	w, h = surface.GetTextSize(text)
	x = MouseX - w / 2

	draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, 120))
	draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 50))
	draw.SimpleText(text, font, x, y, gm:GetTeamColor(trace.Entity))

	y = y + h + 5

	local y1 = 20
	for id, data in pairs(LocalPlayer():MCS_GetEffects()) do
		draw.SimpleText(data.count .. "x " .. id, font, x, y + y1, gm:GetTeamColor(trace.Entity))
		y1 = y1 + 20
	end

	return false
end)