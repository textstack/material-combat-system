local TYPE = {}

TYPE.Set = "armor"
TYPE.ID = "unarmored"
TYPE.ServerName = "Unarmored"
TYPE.Icon = "icon16/star.png"
TYPE.Color = Color(128, 128, 128)

function TYPE:OnTakeDamage(dmg)
	self:MCS_SetArmor(0)
end

MCS.RegisterType(TYPE)