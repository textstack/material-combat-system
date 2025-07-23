local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "splitting"
TYPE.ServerName = "Splitting" -- the server doesn't have access to localization
TYPE.Icon = "icon16/cut_red.png"
TYPE.Color = Color(255,255,255)

TYPE.Order = 1

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_SLASH

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_BUCKSHOT + DMG_SLASH

MCS1.RegisterType(TYPE)