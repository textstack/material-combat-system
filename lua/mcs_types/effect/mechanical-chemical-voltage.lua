local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "mechanical-chemical-voltage"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 2
TYPE.MaxStacks = 1
TYPE.NoTimerResets = true
TYPE.InflictChance = 0.05
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["chemical"] = true,
	["voltage"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:OnApplyEffect(_, effectType)
	if effectType.ID == "mechanical-chemical-voltage" then return true end
end

local movesVert = { IN_FORWARD, IN_BACK }
local movesHori = { IN_LEFT, IN_RIGHT }

local function setMove(ent)
	if not ent:IsPlayer() then return end

	local move = 0
	if math.random() < 0.5 then
		move = movesVert[math.random(#movesVert)]

		if math.random() < 0.5 then
			move = move + movesHori[math.random(#movesHori)]
		end
	else
		move = movesHori[math.random(#movesHori)]

		if math.random() < 0.5 then
			move = move + movesVert[math.random(#movesVert)]
		end
	end

	ent:SetNW2Int("MCS_MechaMove", move)
end

TYPE.EffectFirstApplied = setMove
TYPE.OnEffectProc = setMove

function TYPE:PlayerSetupMove(_, cmd)
	local key = self:GetNW2Int("MCS_MechaMove", -1)
	if key <= 0 then return end

	cmd:SetButtons(bit.bor(cmd:GetButtons(), key))
end

function TYPE:EffectExpired()
	self:SetNW2Int("MCS_MechaMove", -1)
end

MCS.RegisterType(TYPE)