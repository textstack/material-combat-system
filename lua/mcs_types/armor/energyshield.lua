local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "energyshield"
TYPE.ServerName = "Energy Shield"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 192, 128)

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (electricity against kevlar)
]]--

TYPE.Symbols = { "⊡", "⊠" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.0,
	["kinetic"] = 0.0,
	["penetrating"] = 0.0,
	["thermal"] = 1.0,
	["chemical"] = 0.25,
	["electricity"] = 3.0,
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
	["electricity"] = 2.0,
	["subatomic"] = 1
}

function TYPE:PostTakeDamage(dmg, wasDamageTaken)
	if not wasDamageTaken then return end

	local armorAmt = self:MCS_GetArmor()
	local maxArmorAmt = self:MCS_GetMaxArmor()

	if armorAmt <= 0 or armorAmt >= maxArmorAmt then return end

	self:MCS_RemoveTimer("energyshield-recharge")
	self:MCS_RemoveTimer("energyshield-full")

	self:MCS_CreateTimer("energyshield", 5, 1, function()
		local increment = (maxArmorAmt - armorAmt) / 20

		self:MCS_CreateTimer("energyshield-recharge", 0.25, 19, function()
			self:MCS_SetArmor(self:MCS_GetArmor() + increment)
		end)
		self:MCS_CreateTimer("energyshield-full", 5, 1, function()
			self:MCS_SetArmor(maxArmorAmt)
		end)
	end)
end

MCS.RegisterType(TYPE)