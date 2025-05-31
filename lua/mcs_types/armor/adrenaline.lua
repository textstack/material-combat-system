local TYPE = {}

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "adrenaline"
TYPE.ServerName = "Adrenaline" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- armor-specific elements

TYPE.Symbols = { "⛊", "⛉" }

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard (sodium metal & water)
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (voltage against kevlar)
]]--

local dmgMult = 0.25

TYPE.DamageMultipliers = {
	["splitting"] = dmgMult,
	["kinetic"] = dmgMult,
	["penetrating"] = dmgMult,
	["thermal"] = dmgMult,
	["chemical"] = dmgMult,
	["voltage"] = dmgMult,
	["subatomic"] = dmgMult
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
	["splitting"] = 1 - dmgMult,
	["kinetic"] = 1 - dmgMult,
	["penetrating"] = 1 - dmgMult,
	["thermal"] = 1 - dmgMult,
	["chemical"] = 1 - dmgMult,
	["voltage"] = 1 - dmgMult,
	["subatomic"] = 1 - dmgMult
}

local function degenerate(ent)
	ent:MCS_RemoveTimer("adrenaline-increment")

	ent:MCS_CreateTimer("adrenaline", 10, 1, function()
		ent:MCS_CreateTimer("adrenaline-increment", 0.5, 0, function()
			local armorAmt = ent:MCS_GetArmor()
			if armorAmt <= 0 then return end

			local increment = ent:MCS_GetMaxArmor() / 20

			if armorAmt < increment then
				ent:MCS_SetArmor(0)
				ent:SetHealth(ent:Health() - armorAmt)
			else
				ent:MCS_SetArmor(armorAmt - increment)
				ent:SetHealth(ent:Health() - increment)
			end

			-- setting health does not kill you, this will
			if ent:Health() <= 0 then
				ent:MCS_TypelessDamage(1)
			end
		end)
	end)
end

function TYPE:PostTakeDamage(dmg, wasDamageTaken)
	if not wasDamageTaken then return end

	degenerate(self)
end

function TYPE:HandleArmorReduction(dmg)
	local armorAmt = self:MCS_GetArmor()
	local maxArmorAmt = self:MCS_GetMaxArmor()

	if armorAmt < maxArmorAmt then
		self:MCS_SetArmor(math.min(armorAmt + dmg:GetDamage() * MCS.VanillaMag(1 - dmgMult, "armorDrain"), maxArmorAmt))
		dmg:ScaleDamage(MCS.VanillaMag(dmgMult, "armorDamage"))
	end

	return true
end

local function enable(ent)
	ent:MCS_SetArmor(0)
	degenerate(ent)
end

local function disable(ent)
	ent:MCS_RemoveTimer("adrenaline")
	ent:MCS_RemoveTimer("adrenaline-increment")
end

TYPE.OnDeath = disable
TYPE.OnDisabled = disable
TYPE.OnSwitchFrom = disable

TYPE.OnSwitchTo = enable
TYPE.OnEnabled = enable
TYPE.OnPlayerSpawn = enable

MCS.RegisterType(TYPE)