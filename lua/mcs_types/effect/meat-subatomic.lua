local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "meat-subatomic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 60 * 4
TYPE.MaxStacks = 100
TYPE.InflictChance = 0.05
TYPE.Reducible = true
TYPE.FullStackTimer = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

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
	if math.random() < count * 0.01 then return end

	self:MCS_TypelessDamage(self:GetMaxHealth() * 0.05)
end

MCS.RegisterType(TYPE)