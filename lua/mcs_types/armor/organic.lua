local TYPE = {}

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "organic"
TYPE.ServerName = "Organic" -- the server doesn't have access to localization
TYPE.Icon = "icons/armor/organic.png"
TYPE.Color = Color(141, 211, 95)

-- armor-specific elements


-- design for this one was hard.
-- this is supposed to represent any flesh-adjacent or derivative material
-- hard plastic, cardboard, deceased meat,

TYPE.Symbols = { "◙", "●" }
--[[
Multiplier key: 
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (voltage against kevlar)
]]--
TYPE.DamageMultipliers = {
	["splitting"] = 1.0,
	["kinetic"] = 0.75,
	["penetrating"] = 1.0,
	["thermal"] = 0.5,
	["chemical"] = 0.75,
	["voltage"] = 0.25,
	["subatomic"] = 1.0
}
TYPE.DrainRate = {
	["splitting"] = 1.50,--meat is cut very easily, so is cardboard. plastic is not.
	["kinetic"] = 0.5,
	["penetrating"] = 1.25,
	["thermal"] = 0.75,
	["chemical"] = 0.75,
	["voltage"] = 0.75,
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