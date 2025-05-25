local cfgMag = CreateConVar("mcs_damage_magnitude", 1.0, FCVAR_ARCHIVE, "How much to multiply armor/health damage reduction", 0, 1)

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

--- Get a damage multiplier scaled by a magnitude
local function dmgMag(val, mag)
	return (val - 1) * mag + 1
end

--- Code to manage armor
local function armorHandling(ent, dmg)
	if not ent:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if not attacker:MCS_GetEnabled() then return false end

	ent:MCS_TypeHook("HandleArmorReduction", dmg)

	local armorAmt = ent:MCS_GetArmor()
	if armorAmt <= 0 then return false end

	local armorType = ent:MCS_GetArmorType()
	if not armorType then return false end

	local mag = cfgMag:GetFloat()
	local armorMult = armorType.DamageMultipliers
	local armorDrain = armorType.DrainRate
	local totalMult = 1
	local totalDrain = 1
	local multCount = 0
	local drainCount = 0
	for _, dmgType in ipairs(calculateDamageTypes(dmg)) do
		if armorMult and armorMult[dmgType.ID] then
			totalMult = totalMult * dmgMag(armorMult[dmgType.ID], mag)
			multCount = multCount + 1
		end
		if armorDrain and armorDrain[dmgType.ID] then
			totalDrain = totalDrain * dmgMag(armorDrain[dmgType.ID], mag)
			drainCount = drainCount + 1
		end
	end

	multCount = math.max(multCount, 1)
	drainCount = math.max(drainCount, 1)

	local dmgAmt = dmg:GetDamage()
	local newDmgAmt = dmgAmt * dmgMag(totalMult, 1 / multCount)
	local armorDmgAmt = dmgAmt * dmgMag(totalDrain, 1 / drainCount)

	if armorDmgAmt > armorAmt then
		ent:MCS_SetArmor(0)
	else
		ent:MCS_SetArmor(armorAmt - armorDmgAmt)
	end

	dmg:SetDamage(newDmgAmt)
	return false
end

hook.Add("EntityTakeDamage", "MCS_Damage", function(ent, dmg)
	if not ent:MCS_GetEnabled() then return end

	local attacker = dmg:GetAttacker()
	if not attacker:MCS_GetEnabled() then return end

	local attResult = attacker:MCS_TypeHook("OnDealDamage", dmg)
	if attResult then return true end

	local result = ent:MCS_TypeHook("OnTakeDamage", dmg)
	if result then return true end

	local healthType = ent:MCS_GetHealthType()
	if not healthType then return end

	local dmgTypes = calculateDamageTypes(dmg)

	local mag = cfgMag:GetFloat()
	local healthMult = healthType.DamageMultipliers
	local totalMult = 1
	local count = 0
	for _, dmgType in ipairs(dmgTypes) do
		if healthMult and healthMult[dmgType.ID] then
			totalMult = totalMult * dmgMag(healthMult[dmgType.ID], mag)
			count = count + 1
		end
	end

	count = math.max(count, 1)

	local newDmgAmt = dmg:GetDamage() * dmgMag(totalMult, 1 / count)
	dmg:SetDamage(newDmgAmt)

	if not ent:IsPlayer() then
		armorHandling(ent, dmg)
	end

	--TODO: effects
end)

hook.Add("HandlePlayerArmorReduction", "MCS_Damage", armorHandling)