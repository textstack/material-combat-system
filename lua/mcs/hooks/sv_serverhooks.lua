MCS.CreateTypeHook("PostEntityTakeDamage", "PostTakeDamage")
MCS.CreateTypeHook("PlayerSpawn", "OnPlayerSpawn")

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "MCS_EntityKilled", function(data)
	local inflictor = Entity(data.entindex_inflictor)
	local attacker = Entity(data.entindex_attacker)
	local victim = Entity(data.entindex_killed)
	local damageBits = data.damagebits

	if attacker:MCS_GetEnabled() then
		attacker:MCS_TypeHook("OnKill", inflictor, victim, damageBits)
	end

	if victim:MCS_GetEnabled() then
		victim:MCS_TypeHook("OnDeath", inflictor, attacker, damageBits)
		victim:MCS_ClearEffects()
	end
end)

hook.Add("OnEntityCreated", "MCS_OnEntityCreated", function(ent)
	timer.Simple(0, function()
		if IsValid(ent) and ent:MCS_GetEnabled() then
			ent:MCS_TypeHook("OnEnabled")
		end
	end)
end)
