local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-penetrating"
TYPE.ServerName = "Explosive Death"
TYPE.Icon = "icon16/bomb.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 10
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "npc/roller/mine/rmine_predetonate.wav"

TYPE.DamageTypes = {
	["penetrating"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:OnDeath(count)
	self:EmitSound("ambient/explosions/explode_1.wav")
	util.BlastDamage(self, self, self:WorldSpaceCenter(), count * 59, self:GetMaxHealth() * 0.05 * count)
end

MCS1.RegisterType(TYPE)
