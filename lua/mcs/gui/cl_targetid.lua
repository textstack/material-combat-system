local modeCvar = CreateClientConVar("mcs_targetid_mode", -1, true, true, "What MCS1 targetid mode to use. (-1 = let server decide, 0 = off, 1 = minimal, 2 = normal).", -1, 2)
local sModeCvar

local targetIDMult = 0.008
local targetIDPow = 0.5
local targetIDStartFade = 2
local targetIDEndFade = 3
local healthBarScale = 150

surface.CreateFont("MCS1TargetID", {
	font = "Arial",
	size = 30,
	weight = 500,
	antialias = false,
	--outline = true,
})

surface.CreateFont("MCS1TargetID2", {
	font = "Arial",
	size = 12,
	weight = 500,
	antialias = false,
	--outline = true,
})

local function getMode()
	sModeCvar = sModeCvar or GetConVar("mcs_sv_targetid_default_mode")
	local mode = modeCvar:GetInt()

	return mode < 0 and sModeCvar:GetInt() or mode
end

local function entVisible(ent, ply)
	local canSee = ent:MCS_TypeHook("CanBeSeenBy", ply)
	if canSee ~= nil then
		return canSee
	end

	canSee = ply:MCS_TypeHook("CanSee", ent)
	if canSee ~= nil then
		return canSee
	end

	local trEndpos
	local target = ent
	if ent:IsPlayer() and ent:InVehicle() then
		local vehicle = ent:GetVehicle()
		target = vehicle
		trEndpos = target:WorldSpaceCenter()
	else
		local head = target:LookupBone("ValveBiped.Bip01_Head1")
		if head and target:GetBoneMatrix(head) then
			local pos = target:GetBoneMatrix(head):GetTranslation()
			trEndpos = pos
		else
			trEndpos = target:WorldSpaceCenter()
		end
	end

	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = trEndpos,
		filter = ply,
		mask = MASK_SHOT
	})

	return tr.Entity == target
end

local effectData = {}
local mVec = Vector()

local function drawEffect(ent, data, id, x, y)
	local eID = ent:EntIndex()
	effectData[eID] = effectData[eID] or {}
	effectData[eID][id] = effectData[eID][id] or {}
	local eData = effectData[eID][id]

	eData.scale = eData.scale or 1.25
	eData.count = eData.count or MCS1.MAX_EFFECT_COUNT + 1
	eData.procID = eData.procID or data.procID

	if data.count > eData.count or eData.procID ~= data.procID then
		eData.scale = 1.25
	elseif data.count < eData.count and eData.scale < 1.01 then
		eData.scale = 0.95
	end

	eData.procID = data.procID
	eData.count = data.count

	mVec.x = x
	mVec.y = y

	local m = Matrix()
	m:Translate(mVec)
	m:Scale(vector_one * eData.scale)
	m:Translate(-mVec)

	local w = 20
	local effect = MCS1.EffectType(id)
	local color = effect.Color or color_white
	surface.SetDrawColor(color:Unpack())
	surface.SetMaterial(MCS1.GetIconMaterial(effect))

	cam.PushModelMatrix(m, true)

	surface.DrawTexturedRect(x - w / 2, y - w / 2, w, w)

	if data.count > 1 then
		draw.SimpleTextOutlined(string.format("%s x", data.count), "MCS1TargetID2", x + 5, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
	end

	cam.PopModelMatrix()

	eData.scale = MCS1.Dampen(10, eData.scale, 1)
end

local function drawEffects(ent, pos, w)
	local effectList = ent:MCS_GetEffects()
	if table.IsEmpty(effectList) then return end

	local count = table.Count(effectList)

	local x = (count - 1) * 14
	for id, data in SortedPairs(effectList) do
		drawEffect(ent, data, id, pos.x + x, pos.y + 26)
		x = x - 28
	end
end

local nameColor = Color(255, 42, 42)

local function drawNametag(ent, ply, pos)
	local healthType = ent:MCS_GetHealthType()
	local armorType = ent:MCS_GetArmorType()
	if not healthType or not armorType then return end

	local name = "Unnamed"
	local color = nameColor
	if ent:IsPlayer() then
		name = ent:GetName()
		color = team.GetColor(ent:Team())
	else
		name = ent.PrintName or string.format("#%s", ent:GetClass())
	end

	draw.SimpleTextOutlined(name, "MCS1TargetID", pos.x, pos.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black)

	local healthScale = math.Clamp(math.log(ent:GetMaxHealth() / 1000, 10) / 5 + 1, 0.75, 2)
	local w = healthScale * healthBarScale

	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(pos.x - w / 2 - 2, pos.y - 2, w + 4, 16)

	local hp, maxHp = ent:Health(), ent:GetMaxHealth()
	if maxHp > 0 then
		local healthColor = healthType.Color or nameColor
		ent.MCS_PrevHealth = ent.MCS_PrevHealth or hp

		surface.SetDrawColor(healthColor.r, healthColor.g, healthColor.b, 96)
		surface.DrawRect(pos.x - w / 2, pos.y, w * math.min(1, ent.MCS_PrevHealth / maxHp), 12)

		surface.SetDrawColor(healthColor:Unpack())
		surface.DrawRect(pos.x - w / 2, pos.y, w * math.min(1, hp / maxHp), 12)

		surface.SetMaterial(MCS1.GetIconMaterial(healthType))
		surface.DrawTexturedRect(pos.x - w / 2 - 28, pos.y - 6, 24, 24)

		if hp > ent.MCS_PrevHealth then
			ent.MCS_PrevHealth = hp
		else
			ent.MCS_PrevHealth = MCS1.Dampen(4, ent.MCS_PrevHealth, hp)
		end
	end

	local ap, maxAp = ent:MCS_GetArmor(), ent:MCS_GetMaxArmor()
	if maxAp > 0 and not armorType.HideOnTargetID then
		local armorColor = armorType.Color or color_white
		ent.MCS_PrevArmor = ent.MCS_PrevArmor or ap

		surface.SetDrawColor(armorColor.r, armorColor.g, armorColor.b, 96)
		surface.DrawRect(pos.x - w / 2, pos.y + 8, w * math.min(1, ent.MCS_PrevArmor / maxAp), 4)

		surface.SetDrawColor(armorColor:Unpack())
		surface.DrawRect(pos.x - w / 2, pos.y + 8, w * math.min(1, ap / maxAp), 4)

		surface.SetMaterial(MCS1.GetIconMaterial(armorType))
		surface.DrawTexturedRect(pos.x + w / 2 + 4, pos.y - 6, 24, 24)

		if ap > ent.MCS_PrevArmor then
			ent.MCS_PrevArmor = ap
		else
			ent.MCS_PrevArmor = MCS1.Dampen(4, ent.MCS_PrevArmor, ap)
		end
	end

	drawEffects(ent, pos, w)
end

local function drawEnt(ent, ply, onMouse)
	if ent == ply then return end
	if not ent:MCS_GetEnabled() then return end

	if not entVisible(ent, ply) then return end

	local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
	local hullHeight = maxs[3] - mins[3]
	local pos1 = (ent:GetPos() + vector_up * hullHeight * 1.05)
	local pos2 = ent:EyePos() + vector_up * 12

	local pos
	if pos2.z > pos1.z then
		pos = pos2:ToScreen()
	else
		pos = pos1:ToScreen()
	end

	pos.y = pos.y - 10

	if not pos.visible then return end

	mVec.x = pos.x
	mVec.y = pos.y

	local dist = math.pow(ent:WorldSpaceCenter():Distance(ply:WorldSpaceCenter()) * ply:GetFOV(), targetIDPow) * targetIDMult
	if dist > targetIDEndFade then return end

	local alpha = 1 - math.Clamp((dist - targetIDStartFade) * (targetIDEndFade - targetIDStartFade), 0, 1)

	local m = Matrix()
	m:Translate(mVec)
	m:Scale(vector_one / dist)
	m:Translate(-mVec)

	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	cam.PushModelMatrix(m, true)
	surface.SetAlphaMultiplier(alpha)

	drawNametag(ent, ply, pos)

	surface.SetAlphaMultiplier(1)
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

hook.Add("HUDPaint", "MCS_OverheadID", function()
	local ply = LocalPlayer()
	if not ply:MCS_GetEnabled() or getMode() < 2 then return end

	local targets = player.GetAll()
	local lp = ply:GetPos()
	table.sort(targets, function(a, b)
		return a:GetPos():DistToSqr(lp) > b:GetPos():DistToSqr(lp)
	end)

	for _, ent in ipairs(targets) do
		drawEnt(ent, ply)
	end
end)

hook.Add("HUDDrawTargetID", "MCS_TargetID", function()
	local ply = LocalPlayer()
	if not ply:MCS_GetEnabled() then return end

	local mode = getMode()
	if mode <= 0 then return end

	local tr = util.GetPlayerTrace(ply)
	local trace = util.TraceLine(tr)
	if not trace.Hit then return end
	if not trace.HitNonWorld then return end

	local ent = trace.Entity
	if not IsValid(ent) or not ent:MCS_GetEnabled() then return end
	if ent:IsPlayer() and mode >= 2 then return true end

	local dist = math.pow(ent:WorldSpaceCenter():Distance(ply:WorldSpaceCenter()) * ply:GetFOV(), targetIDPow) * targetIDMult
	if dist > targetIDEndFade then return true end

	local canSee = ent:MCS_TypeHook("CanBeSeenBy", ply)
	if canSee == false then return end

	canSee = ply:MCS_TypeHook("CanSee", ent)
	if canSee == false then return end

	local alpha = 1 - math.Clamp((dist - targetIDStartFade) * (targetIDEndFade - targetIDStartFade), 0, 1)

	local mouseX, mouseY = input.GetCursorPos()
	if mouseX == 0 and mouseY == 0 or not vgui.CursorVisible() then
		mouseX, mouseY = ScrW() / 2, ScrH() / 2
	end

	local pos = { x = mouseX, y = mouseY + 50 }
	mVec.x = pos.x
	mVec.y = pos.y

	local m = Matrix()
	m:Translate(mVec)
	m:Scale(vector_one * 0.75)
	m:Translate(-mVec)

	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	cam.PushModelMatrix(m, true)
	surface.SetAlphaMultiplier(alpha)

	drawNametag(ent, ply, pos)

	surface.SetAlphaMultiplier(1)
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()

	return true
end)