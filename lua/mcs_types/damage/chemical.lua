local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "chemical"
TYPE.ServerName = "Chemical" -- the server doesn't have access to localization
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 0, 190)

TYPE.Order = 4

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_NERVEGAS

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_DROWN + DMG_PARALYZE + DMG_NERVEGAS + DMG_POISON + DMG_DROWNRECOVER + DMG_ACID

MCS.RegisterType(TYPE)