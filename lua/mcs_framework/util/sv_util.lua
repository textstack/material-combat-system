util.AddNetworkString("mcs_notify")

local ENTITY = FindMetaTable("Entity")
local mcsEntities = {}

--[[ Set an entity's enabled state for the combat system
	inputs:
		enabled - whether the player has the system enabled
	example:
		jimmy:MCS_SetEnabled(true)
		-- jimmy now has MCS enabled
--]]
function ENTITY:MCS_SetEnabled(enabled)
	if enabled then
		if self:GetNWBool("MCS_Enabled") then return end

		self:SetNWBool("MCS_Enabled", true)
		self:MCS_TypeHook("OnEnabled")
		mcsEntities[self:EntIndex()] = self
	else
		if not self:GetNWBool("MCS_Enabled") then return end

		self:MCS_TypeHook("OnDisabled")
		self:SetNWBool("MCS_Enabled")
		mcsEntities[self:EntIndex()] = nil
	end
end

--- Set the armor of an entity
function ENTITY:MCS_SetArmor(amount)
	if self:IsPlayer() then
		self:SetArmor(amount)
		return
	end

	if self:GetMaxHealth() <= 0 then return end

	self:SetNWFloat("MCS_Armor", amount)
end

--- Set the max armor of an entity
function ENTITY:MCS_SetMaxArmor(amount)
	if self:IsPlayer() then
		self:SetMaxArmor(amount)
		return
	end

	if self:GetMaxHealth() <= 0 then return end

	self:SetNWFloat("MCS_MaxArmor", amount)
end

--[[ Make an entity take direct damage
	inputs:
		amount - the amount of damage
		attacker - the attacker (or nil)
		inflictor - the inflictor (or nil)
--]]
function ENTITY:MCS_TypelessDamage(amount, attacker, inflictor)
	if amount < 0 then
		self:MCS_Heal(-amount)
		return
	end

	local dmg = DamageInfo()

	dmg:SetDamage(amount)
	dmg:SetDamageType(DMG_DIRECT)

	if attacker then
		dmg:SetAttacker(attacker)
	end

	if inflictor then
		dmg:SetInflictor(inflictor)
	end

	self:TakeDamageInfo(dmg)
end

--[[ Make an entity lose armor
	inputs:
		amount - the amount of damage
--]]
function ENTITY:MCS_ArmorDamage(amount)
	if amount < 0 then return end

	self:MCS_SetArmor(math.max(self:MCS_GetArmor() + amount, 0))
end

--[[ Heal an entity by an amount
	inputs:
		amount - the amount of health to heal
--]]
function ENTITY:MCS_Heal(amount)
	if amount < 0 then return end
	if self.MCS_AntiHeal then return end

	local healthAmt = self:Health()
	local maxHealthAmt = self:GetMaxHealth()

	if healthAmt >= maxHealthAmt then return end

	self:SetHealth(math.min(healthAmt + amount, maxHealthAmt))
end

--[[ Repair an entity's armor by an amount
	inputs:
		amount - the amount of armor to repair
--]]
function ENTITY:MCS_RepairArmor(amount)
	if amount < 0 then return end
	if self.MCS_AntiArmor then return end

	local armorAmt = self:MCS_GetArmor()
	local maxArmorAmt = self:MCS_GetMaxArmor()

	if armorAmt >= maxArmorAmt then return end

	self:MCS_SetArmor(math.min(armorAmt + amount, maxArmorAmt))
end

--[[ Set whether an entity can heal
	inputs:
		enabled - if false, entity cannot gain health
--]]
function ENTITY:MCS_SetCanHeal(enabled)
	if enabled then
		self.MCS_PrevHealth = nil
		self.MCS_AntiHeal = nil
		return
	end

	self.MCS_PrevHealth = self:Health()
	self.MCS_AntiHeal = true
end

--[[ Set whether an entity can gain armor
	inputs:
		enabled - if false, entity cannot gain armor
--]]
function ENTITY:MCS_SetCanRepairArmor(enabled)
	if enabled then
		self.MCS_PrevArmor = nil
		self.MCS_AntiArmor = nil
		return
	end

	self.MCS_PrevArmor = self:MCS_GetArmor()
	self.MCS_AntiArmor = true
end

--[[ Returns every entity with MCS enabled
	output:
		the mcs entities; validity not guaranteed
--]]
function MCS.GetMCSEntities()
	return mcsEntities
end

for _, ent in ents.Iterator() do
	if ent:MCS_GetEnabled() then
		mcsEntities[ent:EntIndex()] = ent
	end
end

hook.Add("OnEntityCreated", "MCS_FindMCSEnts", function(ent)
	timer.Simple(0, function()
		if IsValid(ent) and ent:MCS_GetEnabled() then
			mcsEntities[ent:EntIndex()] = ent
		end
	end)
end)

hook.Add("EntityRemoved", "MCS_FindMCSEnts", function(ent)
	mcsEntities[ent:EntIndex()] = nil
end)

hook.Add("PostPlayerDeath", "MCS_RemoveAntiHeal", function(ply)
	ply:MCS_SetCanHeal(true)
	ply:MCS_SetCanRepairArmor(true)
end)

hook.Add("Think", "MCS_AntiHeal", function()
	for _, ent in pairs(mcsEntities) do
		if not IsValid(ent) then continue end

		if ent.MCS_AntiArmor then
			local armorAmt = ent:MCS_GetArmor()

			if ent.MCS_PrevArmor < armorAmt then
				ent:MCS_SetArmor(ent.MCS_PrevArmor)
			end

			ent.MCS_PrevArmor = armorAmt
		end

		if ent.MCS_AntiHeal then
			local healthAmt = ent:Health()

			if ent.MCS_PrevHealth < healthAmt then
				ent:MCS_SetArmor(ent.MCS_PrevHealth)
			end

			ent.MCS_PrevHealth = healthAmt
		end
	end
end)