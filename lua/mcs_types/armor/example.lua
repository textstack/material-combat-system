local TYPE = {}
TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.armor.example.name
-- description key -> mcs.armor.example.desc
-- abbreviation key -> mcs.armor.example.abbr
-- break flavor text key -> mcs.armor.example.flavor

-- generic elements

TYPE.Set = "armor"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = color_white

-- armor-specific elements
-- all of these are optional

TYPE.Symbols = { "⛊", "⛉" }

-- set to true to make the player spawn with 0 armor
TYPE.NoArmorOnSpawn = true

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard (sodium metal & water)
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (voltage against kevlar)
]]--

TYPE.DamageMultipliers = {
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["voltage"] = 1,
	["subatomic"] = 1
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
	["splitting"] = 1,
	["kinetic"] = 1,
	["penetrating"] = 1,
	["thermal"] = 1,
	["chemical"] = 1,
	["voltage"] = 1,
	["subatomic"] = 1
}

-- restricts armor to health class "example"
TYPE.HealthTypes = {
	["example"] = true
}

-- reverse of above (prevents "example" from using this armor)
TYPE.HealthTypeBlacklist = {
	["example"] = true
}

TYPE.HideOnHud = false
TYPE.HideOnTargetID = false

-- hooks (self = player this typeset is applied to)

function TYPE:OnTakeDamage(dmg)
	self:Kill()
end

MCS.RegisterType(TYPE)