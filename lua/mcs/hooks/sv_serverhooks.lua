MCS1.CreateGameTypeHook("PostEntityTakeDamage", "PostTakeDamage")
MCS1.CreateGameTypeHook("PlayerSpawn", "OnPlayerSpawn")

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

MCS1.ANTI_HEAL_CLASS_RESTRICT = {
	["item_healthvial"] = true,
	["item_healthkit"] = true,
	["item_healthcharger"] = true
}

MCS1.ANTI_ARMOR_CLASS_RESTRICT = {
	["item_battery"] = true,
	["item_suitcharger"] = true,
	["item_suit"] = true
}

local function pickupRestrict(ply, item)
	local itemClass = item:GetClass()

	if ply.MCS_AntiHeal and (MCS1.ANTI_HEAL_CLASS_RESTRICT[itemClass] or string.find(itemClass, "health")) then
		return false
	end

	if ply.MCS_AntiArmor and (MCS1.ANTI_ARMOR_CLASS_RESTRICT[itemClass] or string.find(itemClass, "armor") or string.find(itemClass, "suit")) then
		return false
	end
end

local pickupCvar = GetConVar("sv_playerpickupallowed")

hook.Add("PlayerCanPickupItem", "MCS_PreventPickups", pickupRestrict)
hook.Add("PlayerUse", "MCS_PreventPickups", function(ply, item)
	local result = pickupRestrict(ply, item)

	if result ~= false then return result end
	if item:IsPlayerHolding() then return result end
	if not pickupCvar:GetBool() then return result end
	if item.MCS_LastPickup and CurTime() - item.MCS_LastPickup < 0.5 then return result end

	local phys = item:GetPhysicsObject()
	if not IsValid(phys) then return result end
	if phys:GetMass() > 35 then return result end
	if not phys:IsMoveable() then return result end

	if hook.Run("AllowPlayerPickup", ply, item) == false then return result end

	ply:PickupObject(item)
	return result
end)

hook.Add("OnPlayerPhysicsDrop", "MCS_PreventPickups", function(ply, item)
	if not ply.MCS_AntiHeal and not ply.MCS_AntiArmor then return end

	item.MCS_LastPickup = CurTime()
end)