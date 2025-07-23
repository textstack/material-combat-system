local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "meat-subatomic"
TYPE.ServerName = "Radiation Sickness"
TYPE.Icon = "icon16/bricks.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 240
TYPE.MaxStacks = 100
TYPE.InflictChance = 0.05
TYPE.Reducible = true
TYPE.FullStackTimer = true
TYPE.InflictSound = "player/geiger3.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["meat"] = true
}

function TYPE:OnEffectProc(count)
	if self:Health() >= self:GetMaxHealth() then
		self:MCS_RemoveEffect("meat-subatomic")
		return
	end

	self.MCS_MeatSub = not self.MCS_MeatSub
	if self.MCS_MeatSub then return end

	if math.random() > count * 0.01 then return end

	self:MCS_TypelessDamage(self:GetMaxHealth() * 0.05)
end

MCS1.RegisterType(TYPE)
