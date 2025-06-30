local TYPE = {}

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "hazmat"
TYPE.ServerName = "Hazmat" -- the server doesn't have access to localization
TYPE.Icon = "icons/armor/hazmat.png"
TYPE.Color = Color(200, 55, 55)

-- armor-specific elements

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard (sodium metal & water)
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (voltage against kevlar)
]]--

TYPE.Symbols = { "⛊", "⛉" }
TYPE.DamageMultipliers = {
	["splitting"] = 1,
	["kinetic"] = 0.75,
	["penetrating"] = 1,
	["thermal"] = 0.75,
	["chemical"] = 0,
	["voltage"] = 0,
	["subatomic"] = 0
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
	["splitting"] = 3,
	["kinetic"] = 0.5,
	["penetrating"] = 3,
	["thermal"] = 0.75,
	["chemical"] = 0.25,
	["voltage"] = 0.5,
	["subatomic"] = 0.25
}
--[[

restricts armor to health class "example"

when it doesn't exist, no restriction is made.

TYPE.HealthTypes = {
	["example"] = true

]]--

-- hooks (self = player this typeset is applied to)

MCS.RegisterType(TYPE)