local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "unarmored"
TYPE.ServerName = "Unarmored"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(128, 128, 128)

local function noArmor(ent)
	ent:MCS_SetArmor(0)
end

TYPE.OnTakeDamage = noArmor
TYPE.OnSwitchTo = noArmor
TYPE.OnPlayerSpawn = noArmor
TYPE.OnEnabled = noArmor

MCS.RegisterType(TYPE)