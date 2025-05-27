local ENTITY = FindMetaTable("Entity")

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
	else
		if not self:GetNWBool("MCS_Enabled") then return end

		self:MCS_TypeHook("OnDisabled")
		self:SetNWBool("MCS_Enabled")
	end
end

--- Set the armor of an entity
function ENTITY:MCS_SetArmor(amount)
	if self:IsPlayer() then
		self:SetArmor(amount)
		return
	end

	self:SetNWFloat("MCS_Armor", amount)
end

--- Set the max armor of an entity
function ENTITY:MCS_SetMaxArmor(amount)
	if self:IsPlayer() then
		self:SetMaxArmor(amount)
		return
	end

	self:SetNWFloat("MCS_MaxArmor", amount)
end

--[[ Make an entity take direct damage
	inputs:
		amount - the amount of damage
		attacker - the attacker (or nil)
		inflictor - the inflictor (or nil)
--]]
function ENTITY:MCS_TypelessDamage(amount, attacker, inflictor)
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