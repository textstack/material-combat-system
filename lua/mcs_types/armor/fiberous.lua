local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "fiberous"
TYPE.ServerName = "Fiberous"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 192, 128)

--[[
Multiplier key: 
	3.0: 100% critical hits
	2.0: armor reacts violently to this hazard ()
    1.0: doesn't block at all (x-rays against cardboard)
    0.75: cushons against (person fell against dirt as opposed to concrete)
    0.5: absorbs damage from (crumple factor of a car)
    0.25: industrial grade protection against (electricity against kevlar)
]]--

TYPE.Symbols = { "⛊", "⛉" }
TYPE.DamageMultipliers = {
	["splitting"] = 0.5,
	["kinetic"] = 0.75,
	["penetrating"] = 0.5,
	["thermal"] = 0.75,
	["chemical"] = 0.75,
	["electricity"] = 0.25,
	["subatomic"] = 1.0
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
	["splitting"] = 0.25,
	["kinetic"] = 0.5,
	["penetrating"] = 0.75,
	["thermal"] = 0.25,
	["chemical"] = 3.0,
	["electricity"] = 0.25,
	["subatomic"] = 0.25
}

MCS.RegisterType(TYPE)