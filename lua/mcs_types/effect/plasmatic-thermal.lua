local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "plasmatic-thermal"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.MaxStacks = 1
TYPE.InflictChance = 0.1
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["plasmatic"] = true
}

local function chanceUnapply(ent)
	if math.random() < 0.05 then
		ent:MCS_RemoveTypedEffects("thermal")
	end
end

function TYPE:EffectCanApply()
	return self:WaterLevel() <= 1
end

function TYPE:OnEffectProc()
	if self:WaterLevel() > 1 then
		self:MCS_RemoveTypedEffects("thermal")
		return
	end

	chanceUnapply(self)
	self:MCS_TypelessDamage(2)
end

function TYPE:PlayerSetupMove(_, cmd)
	if not cmd:KeyDown(IN_DUCK) then return end

	self.MCS_FireDir = self.MCS_FireDir or IN_FORWARD

	if self.MCS_FireDir ~= IN_FORWARD and cmd:KeyDown(IN_FORWARD) then
		chanceUnapply(self)
		self.MCS_FireDir = IN_FORWARD
		return
	end

	if self.MCS_FireDir ~= IN_BACK and cmd:KeyDown(IN_BACK) then
		chanceUnapply(self)
		self.MCS_FireDir = IN_BACK
		return
	end

	if self.MCS_FireDir ~= IN_LEFT and cmd:KeyDown(IN_LEFT) then
		chanceUnapply(self)
		self.MCS_FireDir = IN_LEFT
		return
	end

	if self.MCS_FireDir ~= IN_RIGHT and cmd:KeyDown(IN_RIGHT) then
		chanceUnapply(self)
		self.MCS_FireDir = IN_RIGHT
		return
	end
end

MCS.RegisterType(TYPE)