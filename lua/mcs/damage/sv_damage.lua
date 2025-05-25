local cfgMag = CreateConVar("mcs_damage_magnitude", 1.0, FCVAR_ARCHIVE, "How much to multiply armor/health damage reduction", 0, 9999)

--- Returns each damage type the damageinfo object is associated with
local function calculateDamageTypes(dmg)
	local gameDamageType = dmg:GetDamageType()

	local dmgTypes = {}
	for _, dmgType in pairs(MCS.GetDamageTypes()) do
		if dmgType.GameDamage and bit.bor(gameDamageType, dmgType.GameDamage) ~= 0 then
			table.insert(dmgTypes, dmgType)
		end
	end

	return dmgTypes
end

--- Get the correct multiplier
local function dmgMag(val, mag)
	return (val - 1) * mag + 1
end

hook.Add("EntityTakeDamage", "MCS_Damage", function(ent, dmg)
	if not ent:IsPlayer() then return end
	if not ent:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if attacker:IsPlayer() then
		if attacker:MCS_GetEnabled() then
			local attResult = attacker:MCS_TypeHook("OnDealDamage", dmg)
			if attResult then return true end
		else
			return
		end
	end

	local result = ent:MCS_TypeHook("OnTakeDamage", dmg)
	if result then return true end

	local healthType = ent:MCS_GetHealthType()
	if not healthType then return end

	local dmgTypes = calculateDamageTypes(dmg)

	local mag = cfgMag:GetFloat()
	local healthMult = healthType.DamageMultipliers
	local totalMult = 1
	for _, dmgType in ipairs(dmgTypes) do
		if healthMult and healthMult[dmgType.ID] then
			totalMult = totalMult * dmgMag(healthMult[dmgType.ID], mag)
		end
	end

	local newDmgAmt = dmg:GetDamage() * totalMult
	dmg:SetDamage(newDmgAmt)

	--TODO: effects
end)

hook.Add("HandlePlayerArmorReduction", "MCS_Damage", function(ply, dmg)
	if not ply:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if attacker:IsPlayer() and not attacker:MCS_GetEnabled() then return false end

	ply:MCS_TypeHook("HandleArmorReduction", dmg)

	local armorAmt = ply:Armor()
	if armorAmt <= 0 then return false end

	local armorType = ply:MCS_GetArmorType()
	if not armorType then return false end

	local mag = cfgMag:GetFloat()
	local armorMult = armorType.DamageMultipliers
	local armorDrain = armorType.DrainRate
	local totalMult = 1
	local totalDrain = 1
	for _, dmgType in ipairs(calculateDamageTypes(dmg)) do
		if armorMult and armorMult[dmgType.ID] then
			totalMult = totalMult * dmgMag(armorMult[dmgType.ID], mag)
		end
		if armorDrain and armorDrain[dmgType.ID] then
			totalDrain = totalDrain * dmgMag(armorDrain[dmgType.ID], mag)
		end
	end

	local dmgAmt = dmg:GetDamage()
	local newDmgAmt = dmgAmt * totalMult
	local armorDmgAmt = dmgAmt - newDmgAmt

	if armorDmgAmt > armorAmt then
		armorDmgAmt = armorAmt
		newDmgAmt = dmgAmt - armorDmgAmt

		ply:SetArmor(0)
	else
		ply:SetArmor(armorAmt - armorDmgAmt)
	end

	dmg:SetDamage(newDmgAmt)
	return false
end)