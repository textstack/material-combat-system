local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "loricate-kinetic"
TYPE.ServerName = "Knockback"
TYPE.Icon = "icon16/asterisk_orange.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0
TYPE.InflictChance = 0.5
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["loricate"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) or not IsValid(dmg:GetDamageForce()) then return end

	local knockback = dmg:GetDamageForce() * 10 * count
	dmg:SetDamageForce(knockback)

	local move = self:GetMoveType()
	if move == MOVETYPE_VPHYSICS or move == MOVETYPE_WALK or move == MOVETYPE_STEP then return end

	if self:IsPlayer() then
		self:SetVelocity(knockback)
		return
	end

	local phys = self:GetPhysicsObject()
	if not IsValid(phys) then return end

	phys:AddVelocity(knockback)
end

MCS.RegisterType(TYPE)
