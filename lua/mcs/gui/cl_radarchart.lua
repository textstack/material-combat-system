local PANEL = {}

local radius = 0.45
local tickWidth = 0.15
local dampSpeed = 10
local startAng = -math.pi / 2

--[[ mcs_radarchart
	A radar chart of multipliers for each damage type
--]]

--[[ Set the data for the chart
	inputs:
		values - a key-pair table in the form of (dmg-id, multiplier)
	usage:
		show off damage multipliers for health and armor types (you can literally just put the DamageMultipliers/ArmorDrain table into this)
		this panel correctly changes its values if you set a new table, and will live-update with damagetype code changes
--]]
function PANEL:SetValues(values)
	if type(values) ~= "table" then return end

	self.Values = values

	self:FixTooltips()
end

--[[ Sets the color of the chart display
	inputs:
		color - the color object representing the color to set the chart to
--]]
function PANEL:SetColor(color)
	if not IsColor(color) then return end

	self.Color = color
	self.BackColor = ColorAlpha(self.Color, self.Color.a / 4)
end

--- everything below is internal stuff!

local lastUpdated = CurTime()

function PANEL:Init()
	self.Values = {}
	self.DmgTypes = {}
	self.MultDisplays = {}
	self.PolyLerp = {}
	self.Color = color_white
	self.BackColor = ColorAlpha(color_white, 64)

	self:RegenerateDamageTypes()
end

function PANEL:Think()
	if lastUpdated > self.LastUpdated then
		self:RegenerateDamageTypes()
	end
end

function PANEL:RegenerateDamageTypes()
	for _, pnl in ipairs(self.DmgTypes) do
		pnl:Remove()
	end

	self.DmgTypes = {}
	self.PolyLerp = {}

	for id, dmgType in pairs(MCS.GetDamageTypes()) do
		local pnl = self:Add("DImage")
		pnl.ID = id

		pnl:SetMaterial(MCS.GetIconMaterial(dmgType))
		pnl:SetSize(16, 16)
		pnl:SetMouseInputEnabled(true)
		pnl:SetTooltipDelay(0)

		table.insert(self.PolyLerp, 0)
		local i = table.insert(self.DmgTypes, pnl)

		self.MultDisplays[i] = self.MultDisplays[i] or self:Add("Panel")
		local pnl1 = self.MultDisplays[i]
		pnl1.ID = id

		pnl1:SetSize(16, 16)
		pnl1:SetMouseInputEnabled(true)
		pnl1:SetTooltipDelay(0)
	end

	self:FixTooltips()

	self.LastUpdated = CurTime()
	self:InvalidateLayout()
end

local function setTooltip(pnl, values)
	local name = MCS.L(string.format("mcs.damage.%s.name", pnl.ID))
	local mult = values[pnl.ID] or 1

	pnl:SetTooltip(string.format("%s\nx %s", name, mult))
end

function PANEL:FixTooltips()
	for _, pnl in ipairs(self.DmgTypes) do
		setTooltip(pnl, self.Values)
	end

	for _, pnl in ipairs(self.MultDisplays) do
		setTooltip(pnl, self.Values)
	end
end

local function getChartScale(val)
	return math.Clamp(1 - math.log(val + 1, 2) * 0.5, 0, 1)
end

function PANEL:PerformLayout(w, h)
	local dmgPnls = self.DmgTypes
	local count = table.Count(dmgPnls)
	local ang = math.rad(360 / count)

	local curAng = startAng
	for _, pnl in ipairs(dmgPnls) do
		local cX = math.cos(curAng) * w * radius + w * 0.5
		local cY = math.sin(curAng) * h * radius + h * 0.5
		curAng = curAng + ang

		pnl:SetPos(cX - 8, cY - 8)
	end

	curAng = startAng
	for _, pnl in ipairs(self.MultDisplays) do
		local mul = self.Values[pnl.ID] or 1
		local r = getChartScale(mul) * radius
		local mX = math.cos(curAng) * w * r + w * 0.5
		local mY = math.sin(curAng) * h * r + h * 0.5
		curAng = curAng + ang

		pnl:SetPos(mX - 8, mY - 8)
	end
end

local function drawChart(polyPoints, count, callback)
	for i = 2, count do
		local point = polyPoints[i]
		local prevPoint = polyPoints[i - 1]

		callback(prevPoint, point)
	end

	if count > 2 then
		local p1 = polyPoints[count]
		local p2 = polyPoints[1]

		callback(p1, p2)
	end
end

local function drawTicks(curAng, w, h)
	for j = 1, 4 do
		local shift = tickWidth / j
		local r = radius * j / 4

		local x1 = math.cos(curAng + shift) * w * r + w * 0.5
		local y1 = math.sin(curAng + shift) * h * r + h * 0.5
		local x2 = math.cos(curAng - shift) * w * r + w * 0.5
		local y2 = math.sin(curAng - shift) * h * r + h * 0.5

		surface.DrawLine(x1, y1, x2, y2)
	end
end

function PANEL:Paint(w, h)
	local dmgPnls = self.DmgTypes
	local count = table.Count(dmgPnls)
	local ang = math.rad(360 / count)

	surface.SetDrawColor(192, 192, 192, 192)

	local polyPoints = {}
	local curAng = startAng
	for i, pnl in ipairs(dmgPnls) do
		local cX = math.cos(curAng) * w * radius + w * 0.5
		local cY = math.sin(curAng) * h * radius + h * 0.5

		surface.DrawLine(w * 0.5, h * 0.5, cX, cY)

		drawTicks(curAng, w, h)

		local mul = self.Values[pnl.ID] or 1
		local oldR = self.PolyLerp[i] or 0
		local newR = getChartScale(mul) * radius
		local r = MCS.Dampen(dampSpeed, oldR, newR)
		self.PolyLerp[i] = r

		local mX = math.cos(curAng) * w * r + w * 0.5
		local mY = math.sin(curAng) * h * r + h * 0.5

		table.insert(polyPoints, { x = mX, y = mY })

		curAng = curAng + ang
	end

	surface.SetDrawColor(self.BackColor:Unpack())
	draw.NoTexture()

	local middle = { x = w * 0.5, y = h * 0.5 }

	drawChart(polyPoints, count, function(p1, p2)
		surface.DrawPoly({ p1, p2, middle })
	end)

	surface.SetDrawColor(self.Color:Unpack())

	drawChart(polyPoints, count, function(p1, p2)
		surface.DrawLine(p1.x, p1.y, p2.x, p2.y)
	end)
end

vgui.Register("mcs_radarchart", PANEL, "Panel")

hook.Add("MCS_LateLoadType", "FixType", function(_type)
	if _type.Set == "damage" then
		lastUpdated = CurTime()
	end
end)

--[[ testing code
if MCS_LOADED then
	local frame = vgui.Create("DFrame")
	frame:MakePopup()
	frame:SetSize(300, 300)
	frame:Center()
	frame:SetSizable(true)

	local chart = frame:Add("mcs_radarchart")
	chart:Dock(FILL)
	chart:SetValues(MCS.HealthType("meat").DamageMultipliers)
	chart:SetColor(Color(255, 64, 64))
end
--]]