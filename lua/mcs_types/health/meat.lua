local TYPE = {}

TYPE.Set = "health"
TYPE.ID = "meat"
TYPE.ServerName = "Meat"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(255, 64, 64)

--[[
Damage key:
    1.75: softball-sized hole in your body for every hit (ligneous creature vs flamethrower)
	1.5: each hit rips limbs off of your body without much effort (bullets against unarmored meat)
	1.25: very quickly lethal (spear stuck in torso)
    1.0: things can get nasty (knife fight)
    0.75: unlikely to kill you as fast as a knife would (being pummeled to death by somebody's bare hands)
    0.5: can kill you if you get caught off guard (being tazed to death or experiencing an unfortunately long fire proc)
    0.25: what doesn't kill you probably kills you later! (continuous x-ray attack against meat)
]]--


TYPE.BloodColor = BLOOD_COLOR_RED
TYPE.DamageMultipliers = {
	["splitting"] = 1.75, --being sliced by a sword is rough
	["kinetic"] = 1.0, --people tend to recover from intense forces but still often do not
	["penetrating"] = 1.5, --being shot drops you a little bit slower than being sliced
	["thermal"] = 0.5, --taking too many burns too quickly can kill you from shock
	["chemical"] = 0.75, --toxins like mustard gas drop you faster than a stabbing would
	["voltage"] = 1.25, --it's easy to be tazed to death while expending the same amount of energy used in a gun or blade
	["subatomic"] = 0.25 --this will just kill you later
}

MCS.RegisterType(TYPE)