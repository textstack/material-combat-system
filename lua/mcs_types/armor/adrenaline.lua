local TYPE = {}

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Set = "armor"
TYPE.ID = "adrenaline"
TYPE.ServerName = "Adrenaline" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- armor-specific elements

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard (sodium metal & water)
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (electricity against kevlar)
]]--

TYPE.Symbols = { "⛊", "⛉" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.25,
	["kinetic"] = 0.25,
	["penetrating"] = 0.25,
	["thermal"] = 0.25,
	["chemical"] = 0.25,
	["electricity"] = 0.25,
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
	["splitting"] = 0,
	["kinetic"] = 0,
	["penetrating"] = 0,
	["thermal"] = 0,
	["chemical"] = 0,
	["electricity"] = 0,
	["subatomic"] = 0
}

local function degenerate(ent)
	ent.MCS_Adrenaline = true
	local increment = ent:MCS_GetArmor() / 20

	ent:MCS_CreateTimer("adrenaline-increment", 0.5, 0, function()
		local newAmt = ent:MCS_GetArmor() - increment
		local healthSub = 0
		if newAmt < 0 then
			healthSub = newAmt
			newAmt = 0
		end

		ent:MCS_SetArmor(newAmt)
		ent:SetHealth(ent:Health() - increment - healthSub)

		if ent:Health() <= 0 then
			ent:TakeDamage(1)
		end

		if newAmt <= 0 then
			ent:MCS_RemoveTimer("adrenaline-increment")
		end
	end)
end

function TYPE:PostTakeDamage(dmg, wasDamageTaken)
	if not wasDamageTaken then return end

	local armorAmt = self:MCS_GetArmor()
	local maxArmorAmt = self:MCS_GetMaxArmor()

	if self.MCS_Adrenaline then
		self:MCS_RemoveTimer("adrenaline")
		self:MCS_RemoveTimer("adrenaline-increment")
		self.MCS_Adrenaline = nil
	end

	if armorAmt < maxArmorAmt then
		self:MCS_SetArmor(math.min(armorAmt + dmg:GetDamage() * 0.75, maxArmorAmt))
	end

	if not self:MCS_TimerExists("adrenaline") then
		self:MCS_CreateTimer("adrenaline", 10, 1, function()
			degenerate(self, armorAmt)
		end)
	end
end

function TYPE:HandleArmorReduction(dmg)
	if self:MCS_GetArmor() < self:MCS_GetMaxArmor() then
		dmg:ScaleDamage(0.25)
	end

	return true
end

local function enable(ent)
	ent:MCS_SetArmor(0)
end

local function disable(ent)
	ent:MCS_RemoveTimer("adrenaline")
	ent:MCS_RemoveTimer("adrenaline-increment")
	ent.MCS_Adrenaline = nil
end

TYPE.OnDeath = disable
TYPE.OnDisabled = disable
TYPE.OnSwitchFrom = disable

TYPE.OnSwitchTo = enable
TYPE.OnEnabled = enable
TYPE.OnPlayerSpawn = enable

MCS.RegisterType(TYPE)