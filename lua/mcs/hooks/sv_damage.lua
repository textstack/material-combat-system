local cfgMag = CreateConVar("mcs_sv_damage_vanillaness", 0.0, FCVAR_ARCHIVE, "How 'close to vanilla' the damage calculations should be on a scale from 0 to 1", 0.0, 1.0)

--- Returns each damage type the damageinfo object is associated with
local function calculateDamageTypes(dmg)
	local gameDamageType = dmg:GetDamageType()

	local dmgTypes = {}
	for dmgID, dmgType in pairs(MCS.GetDamageTypes()) do
		if dmgType.GameDamage and bit.bor(gameDamageType, dmgType.GameDamage) ~= 0 then
			dmgTypes[dmgID] = dmgType
		end
	end

	return dmgTypes
end

--- Operation for multiplying damage types over a table of multipliers
local function multiplyStat(dmgTypes, mults, center)
	if not mults or table.IsEmpty(mults) then return 1 end

	local mag = 1 - cfgMag:GetFloat()
	local totalMult = 1
	local count = 0
	for _, dmgType in pairs(dmgTypes) do
		if mults[dmgType.ID] then
			totalMult = totalMult * MCS.Magnitude(healthMult[dmgType.ID], mag, center)
			count = count + 1
		end
	end

	local reduce = 1 / math.max(count, 1)
	return math.pow(totalMult, reduce), reduce
end

--- Code to manage armor
local function armorHandling(ent, dmg)
	if not ent:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if IsValid(attacker) and not attacker:MCS_GetEnabled() then return end

	local result = ent:MCS_TypeHook("HandleArmorReduction", dmg)
	if result then return false end

	local armorAmt = ent:MCS_GetArmor()
	if armorAmt <= 0 then return false end

	local armorType = ent:MCS_GetArmorType()
	if not armorType then return false end

	local dmgAmt = dmg:GetDamage()
	local dmgTypes = calculateDamageTypes(dmg)
	local newDmgAmt = dmgAmt * multiplyStat(dmgTypes, armorType.DamageMultipliers, 0.2)
	local armorDmgAmt = dmgAmt * multiplyStat(dmgTypes, armorType.DrainRate, 0.8)

	ent:MCS_SetArmor(math.max(armorAmt - armorDmgAmt, 0))
	dmg:SetDamage(newDmgAmt)

	return false
end

hook.Add("HandlePlayerArmorReduction", "MCS_Damage", armorHandling)

hook.Add("EntityTakeDamage", "MCS_Damage", function(ent, dmg)
	local attacker = dmg:GetAttacker()
	if not ent:MCS_GetEnabled() then
		if IsValid(attacker) and attacker:MCS_GetEnabled() then return true end
		return
	end
	if not IsValid(attacker) then return end
	if not attacker:MCS_GetEnabled() then return true end

	local attResult = attacker:MCS_TypeHook("OnDealDamage", dmg)
	if attResult then return true end

	local result = ent:MCS_TypeHook("OnTakeDamage", dmg)
	if result then return true end

	local healthType = ent:MCS_GetHealthType()
	if not healthType then return end

	local augment = attacker:MCS_GetCurrentAugment(dmg:GetInflictor())
	if augment and augment.GameDamage then
		dmg:SetDamageType(bit.bor(dmg:GetDamageType(), augment.GameDamage))
	end

	local dmgTypes = calculateDamageTypes(dmg)
	local mult, reduce = multiplyStat(dmgTypes, healthType.DamageMultipliers, 1)
	local newDmgAmt = dmg:GetDamage() * mult

	dmg:SetDamage(newDmgAmt)

	if not ent:IsPlayer() then
		armorHandling(ent, dmg)
	end

	for effectID, effectType in pairs(MCS.GetEffectTypes()) do
		if not effectType.InflictChance then continue end
		if math.random() > effectType.InflictChance then continue end
		if effectType.Reducible and math.random() > reduce then continue end

		if effectType.HealthTypes and not effectType.HealthTypes[healthType.ID] then continue end
		if effectType.HealthTypeBlacklist and effectType.HealthTypeBlacklist[healthType.ID] then continue end

		if effectType.DamageTypes then
			local succeed
			for dmgID, _ in pairs(dmgTypes) do
				if effectType.DamageTypes[dmgID] then
					succeed = true
					break
				end
			end

			if not succeed then continue end
		end

		if effectType.DamageTypeBlacklist then
			local fail
			for dmgID, _ in pairs(dmgTypes) do
				if effectType.DamageTypes[dmgID] then
					fail = true
					break
				end
			end

			if fail then continue end
		end

		ent:MCS_AddEffect(effectID, effectType.Burst)
	end
end)