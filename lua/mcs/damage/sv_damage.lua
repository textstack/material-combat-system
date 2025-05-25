hook.Add("EntityTakeDamage", "MCS_Damage", function(target, dmg)
	if not target:IsPlayer() then return end
	if not target:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if not attacker:IsPlayer() then return end
	if not attacker:MCS_GetEnabled() then return end

	local result = target:MCS_TypeHook("OnTakeDamage", dmg)
	if result then return true end

	local attResult = attacker:MCS_TypeHook("OnDealDamage", dmg)
	if attResult then return true end

	--TODO: damage multipliers, armor handling, effects
end)