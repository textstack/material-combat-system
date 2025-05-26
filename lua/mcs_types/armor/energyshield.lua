local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "energyshield"
TYPE.ServerName = "Energy Shield"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 192, 128)

TYPE.Symbols = { "⊡", "⊠" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.0,
	["kinetic"] = 0.0,
	["penetrating"] = 0.0,
	["thermal"] = 1.0,
	["chemical"] = 0.0,
    ["electricity"] = 3.0,
	["subatomic"] = 0.25
}

TYPE.DrainRate = {
	["splitting"] = 0.75,
	["kinetic"] = 4.5,
	["penetrating"] = 2.25,
	["thermal"] = 0.25,
	["chemical"] = 0.0,
    ["electricity"] = 4.5,
	["subatomic"] = 1.0
}
TYPE.HealthTypes = {
	["meat"] = true
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

		self:MCS_CreateTimer("energyshield-recharge", 0.25, 20, function()
			self:MCS_SetArmor(self:MCS_GetArmor() + increment)
		end)
		self:MCS_CreateTimer("energyshield-full", 5, 1, function()
			self:MCS_SetArmor(maxArmorAmt)
		end)
	end)
end

MCS.RegisterType(TYPE)