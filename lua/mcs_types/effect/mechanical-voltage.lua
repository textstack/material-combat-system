local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-voltage"
TYPE.ServerName = "Malfunction"
TYPE.Icon = "icon16/cog_delete.png"
TYPE.Color = color_white

TYPE.BaseTime = 2
TYPE.MaxStacks = 1
TYPE.NoTimerResets = true
TYPE.InflictChance = 0.05
TYPE.Reducible = true
TYPE.InflictSound = "npc/manhack/bat_away.wav"

TYPE.DamageTypes = {
	["voltage"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:OnApplyEffect(_, effectType)
	if effectType.ID == "mechanical-voltage" or effectType.ID == "mechanical-chemical" then return true end
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

function TYPE:PlayerStartCommand(_, cmd)
	local key = self:GetNW2Int("MCS_MechaMove", -1)
	if key <= 0 then return end

	cmd:SetButtons(bit.bor(cmd:GetButtons(), key))

	if bit.band(key, IN_FORWARD) == IN_FORWARD then
		cmd:SetForwardMove(10000)
	elseif bit.band(key, IN_BACK) == IN_BACK then
		cmd:SetForwardMove(-10000)
	end

	if bit.band(key, IN_RIGHT) == IN_RIGHT then
		cmd:SetSideMove(10000)
	elseif bit.band(key, IN_LEFT) == IN_LEFT then
		cmd:SetSideMove(-10000)
	end
end

function TYPE:EffectExpired()
	self:SetNW2Int("MCS_MechaMove", -1)
end

MCS1.RegisterType(TYPE)
