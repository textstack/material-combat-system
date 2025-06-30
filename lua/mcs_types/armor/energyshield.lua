local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "energyshield"
TYPE.ServerName = "Energy Shield"
TYPE.Icon = "icons/armor/energyshield.png"
TYPE.Color = Color(212, 0, 170)

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (voltage against kevlar)
]]--

TYPE.Symbols = { "⊡", "⊠" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.0,
	["kinetic"] = 0.0,
	["penetrating"] = 0.0,
	["thermal"] = 1.0,
	["chemical"] = 0.25,
	["voltage"] = 3.0,
	["subatomic"] = 0.25
}

--[[
Drain key: 
	3.0: squidward trying to gently chisel marble
	2.0: armor is extremely weak against this hazard (wood or cardboard on fire)
    1.0: armor deforms for 100% of the damage it takes (crumple factor of a car)
    0.75: armor naturally resists this (kevlar might be able to take a bullet or 2)
    0.5: armor isn't very quickly depleted by this hazard (killing a vampire entirely with prayer)
    0.25: certified for 1000 hours of continuous operation against this hazard (steel against splitting)
]]--

TYPE.DrainRate = {
	["splitting"] = 0.5,
	["kinetic"] = 3.0,
	["penetrating"] = 3.0,
	["thermal"] = 0.5,
	["chemical"] = 0.25,
	["voltage"] = 2.0,
	["subatomic"] = 1
}

local function initShield(ent)
	ent:MCS_RemoveTimer("energyshield-recharge")

	ent:MCS_CreateTimer("energyshield", 5, 1, function()
		ent:MCS_CreateTimer("energyshield-recharge", 0.25, 0, function()
			local armorAmt = ent:MCS_GetArmor()
			local maxArmorAmt = ent:MCS_GetMaxArmor()
			if armorAmt >= maxArmorAmt then return end

			local newAmt = math.min(armorAmt + maxArmorAmt / 20, maxArmorAmt)
			ent:MCS_SetArmor(newAmt)
		end)
	end)
end

function TYPE:PostTakeDamage(_, wasDamageTaken)
	if not wasDamageTaken then return end

	initShield(self)
end

function TYPE:OnArmorChanged(prevArmor, armor)
	if prevArmor < armor then return end

	initShield(self)
end

local function disable(ent)
	ent:MCS_RemoveTimer("energyshield-recharge")
	ent:MCS_RemoveTimer("energyshield")
end

TYPE.OnDeath = disable
TYPE.OnDisabled = disable
TYPE.OnSwitchFrom = disable

TYPE.OnSwitchTo = initShield
TYPE.OnPlayerSpawn = initShield
TYPE.OnEnabled = initShield

MCS.RegisterType(TYPE)