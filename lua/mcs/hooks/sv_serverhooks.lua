MCS.CreateGameTypeHook("PostEntityTakeDamage", "PostTakeDamage")
MCS.CreateGameTypeHook("PlayerSpawn", "OnPlayerSpawn")

gameevent.Listen("entity_killed")
hook.Add("entity_killed", "MCS_EntityKilled", function(data)
	local inflictor = Entity(data.entindex_inflictor or -1)
	local attacker = Entity(data.entindex_attacker or -1)
	local victim = Entity(data.entindex_killed or -1)
	local damageBits = data.damagebits

	if IsValid(attacker) and attacker:MCS_GetEnabled() then
		attacker:MCS_TypeHook("OnKill", inflictor, victim, damageBits)
	end

	if IsValid(victim) and victim:MCS_GetEnabled() then
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
--[[
	On spawn, set a player's max health and armor to what they have selected or 100 if it has not been set.
]]--
hook.Add("PlayerSpawn", "MCS_PlayerSpawnHpArmor", function(ply)
	timer.Simple(0, function()
		if not ply:IsValid() or not ply:MCS_GetEnabled() then return end

		if ply.MCS_MaxHealth then
			ply:SetMaxHealth(ply.MCS_MaxHealth) -- TODO: server setting for default max health?
			ply:SetHealth(ply.MCS_MaxHealth)
		end

		if ply.MCS_MaxArmor then
			ply:SetMaxArmor(ply.MCS_MaxArmor)
		end

		if not ply:MCS_GetArmorTypeValue("NoArmorOnSpawn") then
			ply:SetArmor(ply:GetMaxArmor())
		end
	end)
end
)