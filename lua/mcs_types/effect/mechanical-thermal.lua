local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-thermal"
TYPE.ServerName = "Strong Knockback"
TYPE.Icon = "icon16/fire.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.MaxStacks = 10
TYPE.InflictChance = 0.15
TYPE.Reducible = true
TYPE.InflictSound = "doors/heavy_metal_stop1.wav"

TYPE.DamageTypes = {
	["thermal"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

local hori = Vector(0.15, 0.15, 0)

function TYPE:OnTakeDamage(count, dmg)
	local knockback = dmg:GetDamageForce()
	knockback = knockback + knockback * hori * count
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

MCS1.RegisterType(TYPE)
