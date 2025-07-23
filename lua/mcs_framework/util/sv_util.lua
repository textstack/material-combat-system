util.AddNetworkString("mcs_notify")

local ENTITY = FindMetaTable("Entity")
local mcsEntities = {}

--[[ Set an entity's enabled state for the combat system
	inputs:
		enabled - whether the player has the system enabled
	example:
		jimmy:MCS_SetEnabled(true)
		-- jimmy now has MCS1 enabled
--]]
function ENTITY:MCS_SetEnabled(enabled)
	if enabled then
		if self:GetNWBool("MCS_Enabled") then return end

		self:SetNWBool("MCS_Enabled", true)
		self:MCS_TypeHook("OnEnabled")
		mcsEntities[self:EntIndex()] = self

		if self:IsPlayer() then
			local color = self:MCS_GetHealthTypeValue("BloodColor")
			if color then
				self:SetBloodColor(color)
			end
		end
	else
		if not self:GetNWBool("MCS_Enabled") then return end

		self:MCS_TypeHook("OnDisabled")
		self:SetNWBool("MCS_Enabled")
		mcsEntities[self:EntIndex()] = nil

		if self:IsPlayer() then
			self:SetBloodColor(BLOOD_COLOR_RED)
		end
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
	else
		dmg:SetAttacker(self)
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
		self.MCS_AntiHeal = nil
		return
	end

	self.MCS_AntiHeal = true
end

--[[ Set whether an entity can gain armor
	inputs:
		enabled - if false, entity cannot gain armor
--]]
function ENTITY:MCS_SetCanRepairArmor(enabled)
	if enabled then
		self.MCS_AntiArmor = nil
		return
	end

	self.MCS_AntiArmor = true
end

--[[ Returns every entity with MCS1 enabled
	output:
		the mcs entities; validity not guaranteed
--]]
function MCS1.GetMCS1Entities()
	return mcsEntities
end

for _, ent in ents.Iterator() do
	if ent:MCS_GetEnabled() then
		mcsEntities[ent:EntIndex()] = ent
	end
end

hook.Add("OnEntityCreated", "MCS_FindMCS1Ents", function(ent)
	timer.Simple(0, function()
		if IsValid(ent) then
			if ent.NPCName then
				ent:SetNWString("NPCName", ent.NPCName)
			end

			if ent:MCS_GetEnabled() then
				mcsEntities[ent:EntIndex()] = ent
			end
		end
	end)
end)

hook.Add("EntityRemoved", "MCS_FindMCS1Ents", function(ent)
	mcsEntities[ent:EntIndex()] = nil
end)

hook.Add("PostPlayerDeath", "MCS_RemoveAntiHeal", function(ply)
	ply:MCS_SetCanHeal(true)
	ply:MCS_SetCanRepairArmor(true)
end)

hook.Add("Think", "MCS_AntiHeal", function()
	for _, ent in pairs(mcsEntities) do
		if not IsValid(ent) then continue end

		local armorAmt = ent:MCS_GetArmor()

		-- hack: clear off negative armor if it somehow happens
		if armorAmt < 0 then
			armorAmt = 0
			ent:MCS_SetArmor(0)
		end

		if ent.MCS_PrevArmor and ent.MCS_PrevArmor ~= armorAmt then
			if ent.MCS_AntiArmor and ent.MCS_PrevArmor < armorAmt then
				ent:MCS_SetArmor(ent.MCS_PrevArmor)
			else
				ent:MCS_TypeHook("OnArmorChanged", ent.MCS_PrevArmor, armorAmt)
			end
		end

		ent.MCS_PrevArmor = armorAmt

		local healthAmt = ent:Health()

		if ent.MCS_PrevHealth and ent.MCS_PrevHealth ~= healthAmt then
			if ent.MCS_AntiHeal and ent.MCS_PrevHealth < healthAmt then
				ent:SetHealth(ent.MCS_PrevHealth)
			else
				ent:MCS_TypeHook("OnHealthChanged", ent.MCS_PrevHealth, healthAmt)
			end
		end

		ent.MCS_PrevHealth = healthAmt
	end
end)