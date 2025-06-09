local PANEL = {}

local radius = 0.45
local tickWidth = 0.15
local dampSpeed = 10

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

--- everything below is internal stuff!

local lastUpdated = CurTime()

function PANEL:Init()
	self.Values = {}
	self.DmgTypes = {}
	self.PolyLerp = {}

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
		table.insert(self.DmgTypes, pnl)
	end

	self:FixTooltips()

	self.LastUpdated = CurTime()
	self:InvalidateLayout()
end

function PANEL:FixTooltips()
	for _, pnl in ipairs(self.DmgTypes) do
		local name = MCS.L(string.format("mcs.damage.%s.name", pnl.ID))
		local mult = self.Values[pnl.ID] or 1

		pnl:SetTooltip(string.format("%s\nx %s", name, mult))
	end
end

function PANEL:PerformLayout(w, h)
	local dmgPnls = self.DmgTypes
	local count = table.Count(dmgPnls)
	local ang = math.rad(360 / count)

	local curAng = -math.pi / 2
	for _, pnl in ipairs(dmgPnls) do
		local cX = math.cos(curAng) * w * radius + w * 0.5
		local cY = math.sin(curAng) * h * radius + h * 0.5
		curAng = curAng + ang

		pnl:SetPos(cX - 8, cY - 8)
	end
end

function PANEL:Paint(w, h)
	local dmgPnls = self.DmgTypes
	local count = table.Count(dmgPnls)
	local ang = math.rad(360 / count)

	surface.SetDrawColor(192, 192, 192, 192)

	local polyPoints = {}
	local curAng = -math.pi / 2
	for i, pnl in ipairs(dmgPnls) do
		local cX = math.cos(curAng) * w * radius + w * 0.5
		local cY = math.sin(curAng) * h * radius + h * 0.5

		surface.DrawLine(w * 0.5, h * 0.5, cX, cY)

		for j = 1, 4 do
			local shift = tickWidth / j
			local r = radius * j / 4

			local x1 = math.cos(curAng + shift) * w * r + w * 0.5
			local y1 = math.sin(curAng + shift) * h * r + h * 0.5
			local x2 = math.cos(curAng - shift) * w * r + w * 0.5
			local y2 = math.sin(curAng - shift) * h * r + h * 0.5

			surface.DrawLine(x1, y1, x2, y2)
		end

		local mul = self.Values[pnl.ID] or 1

		local oldR = self.PolyLerp[i] or 0
		local newR = math.Clamp(1 - math.log(mul + 1, 2) * 0.5, 0, 1) * radius
		local r = MCS.Dampen(dampSpeed, oldR, newR)
		self.PolyLerp[i] = r

		local mX = math.cos(curAng) * w * r + w * 0.5
		local mY = math.sin(curAng) * h * r + h * 0.5

		table.insert(polyPoints, { x = mX, y = mY })

		curAng = curAng + ang
	end

	surface.SetDrawColor(255, 255, 255)

	for i, point in ipairs(polyPoints) do
		if i == 1 then continue end
		local prevPoint = polyPoints[i - 1]

		surface.DrawLine(prevPoint.x, prevPoint.y, point.x, point.y)
	end

	if count > 2 then
		local p1 = polyPoints[1]
		local p2 = polyPoints[count]

		surface.DrawLine(p1.x, p1.y, p2.x, p2.y)
	end
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
end
--]]