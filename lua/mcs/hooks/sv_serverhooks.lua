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
hook.Add("PlayerSpawn","MCS_PlayerSpawnHpArmor", function(player, transition) 
	if player:MCS_GetEnabled() then
		-- Because player_manager.lua sets the player's max health on spawn (and I don't see any way to change it), this jank works around it.
		timer.Simple( 0.1, function() 
			player:SetMaxHealth(player.MCS_MaxHealth or 100) -- TODO: server setting for default max health?
			player:SetHealth(player.MCS_MaxHealth or 100)
			player:SetMaxArmor(player.MCS_MaxArmor or 100)
			player:SetArmor(player.MCS_MaxArmor or 100)  -- TODO: If Armor has TYPE.NoArmorOnSpawn, do not set.
		end )
	end
end
)