local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "kinetic"
TYPE.ServerName = "Kinetic" -- the server doesn't have access to localization
TYPE.Icon = "icon16/asterisk_orange.png"
TYPE.Color = Color(255,255,255)

TYPE.Order = 0

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_SONIC

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_CRUSH + DMG_VEHICLE + DMG_FALL + DMG_BLAST + DMG_CLUB + DMG_SONIC + DMG_BLAST_SURFACE

-- generic damage only applies when damage has *no* other type
TYPE.Generic = true

MCS1.RegisterType(TYPE)