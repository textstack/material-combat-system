local TYPE = {}

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "metallic"
TYPE.ServerName = "Metallic" -- the server doesn't have access to localization
TYPE.Icon = "mcs_icons/armor/metallic.png"
TYPE.Color = Color(95, 95, 211)

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

TYPE.Symbols = { "⚙", "🛆" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.25,
	["kinetic"] = 1, --modern vehicles crumple for a reason
	["penetrating"] = 0.5,
	["thermal"] = 1,
	["chemical"] = 0.25,
	["voltage"] = 1,
	["subatomic"] = 0.5
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

TYPE.DrainRates = {
	["splitting"] = 0.25,
	["kinetic"] = 2,
	["penetrating"] = 0.5,
	["thermal"] = 0,
	["chemical"] = 0.5,
	["voltage"] = 1,
	["subatomic"] = 2
}
--[[

restricts armor to health class "example"

when it doesn't exist, no restriction is made.

TYPE.HealthTypes = {
	["example"] = true

]]--

-- hooks (self = player this typeset is applied to)


MCS.RegisterType(TYPE)