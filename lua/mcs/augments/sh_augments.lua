local ENTITY = FindMetaTable("Entity")

local function defaultAug(ent)
	return MCS1.GetNPCData(ent:MCS_GetSpawnName())[3]
end

--[[ Gives an entity's augment for the current damage instance
	inputs:
		inflictor - the weapon used to deal the damage, or nil if no weapon was used
	output:
		the damage type for the augment, or nil if there is none
--]]
function ENTITY:MCS_GetCurrentAugment(inflictor)
	if self.MCS_Augment then return self.MCS_Augment end

	if not self:IsPlayer() then return defaultAug(self) end
	if not self.MCS_Augments then return defaultAug(self) end
	if not IsValid(inflictor) then return defaultAug(self) end

	local dType = MCS1.DamageType(self.MCS_Augments[inflictor:GetClass()])
	if not dType then return defaultAug(self) end

	return dType
end

--[[ Remove an augment from an entity or its weapon
	inputs:
		swep - class name of the weapon (if the entity is a player)
		force - serverside, set to true to bypass the one-per-life restriction for players
	outputs:
		whether the operation was successful
		the tag for the error message if failed
--]]
function ENTITY:MCS_ClearAugment(swep, force)
	return self:MCS_SetAugment(nil, swep, force)
end

--[[ Set the augment of an entity or its weapon
	inputs:
		id - id of the damage type for the augment
		swep - class name of the weapon (if the entity is a player)
		force - serverside, set to true to bypass the one-per-life restriction for players
	outputs:
		whether the operation was successful
		the tag for the error message if failed
	usage:
		clientside, use this to request an augment for the weapon
		serverside, use this for npcs and stuff and forcing augments on players
--]]
function ENTITY:MCS_SetAugment(id, swep, force)
	local damageType = MCS1.DamageType(id)
	if not damageType or not damageType.AugmentDamage or (not force and damageType.Hidden) then
		id = nil
	end

	if not self:IsPlayer() then
		self.MCS_Augment = id
		return true
	end

	if not swep then
		local weapon = self:GetActiveWeapon()
		if not IsValid(weapon) then return false, "mcs.error.invalid_active_weapon" end

		swep = weapon:GetClass()
	end

	if CLIENT then
		if self ~= LocalPlayer() then return false, "mcs.error.self_only" end

		if not force and self.MCS_HasSetAugments and self.MCS_HasSetAugments[swep] then
			return false, "mcs.error.already_set_augment"
		end

		net.Start("mcs_augments")
		net.WriteString(swep)
		net.WriteString(id or "")
		net.SendToServer()

		return true
	end

	if self:IsPlayer() then
		if not force and self.MCS_HasSetAugments and self.MCS_HasSetAugments[swep] then
			return false, "mcs.error.already_set_augment"
		end

		self.MCS_HasSetAugments = self.MCS_HasSetAugments or {}
		self.MCS_HasSetAugments[swep] = true

		net.Start("mcs_augments")
		net.WriteString(swep)
		net.WriteString(id or "")
		net.Send(self)
	end

	self.MCS_Augments = self.MCS_Augments or {}
	self.MCS_Augments[swep] = id

	return true
end