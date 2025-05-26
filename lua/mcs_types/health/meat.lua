local TYPE = {}

TYPE.Set = "health"
TYPE.ID = "meat"
TYPE.ServerName = "Meat"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 64, 64)

--[[
Damage key: 
	1.5: each hit rips limbs off of your body without much effort (ligneous creature vs flamethrower)
	1.25: very quickly lethal (bullets against unarmored meat)
    1.0: things can get nasty (knife fight)
    0.75: unlikely to kill you as fast as a knife would (being pummeled to death by somebody's bare hands)
    0.5: can kill you if you get caught off guard (being tazed to death or experiencing an unfortunately long fire proc)
    0.25: what doesn't kill you probably kills you later! (continuous x-ray attack against meat)
]]--


TYPE.BloodColor = BLOOD_COLOR_RED
TYPE.DamageMultipliers = {
	["splitting"] = 1.50,
	["kinetic"] = 1.0,
	["penetrating"] = 1.25,
	["thermal"] = 0.75,
	["chemical"] = 0.75,
	["electricity"] = 1.25,
	["subatomic"] = 0.25
}

MCS.RegisterType(TYPE)