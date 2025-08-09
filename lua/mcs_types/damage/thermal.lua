local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "thermal"
TYPE.ServerName = "Thermal" -- the server doesn't have access to localization
TYPE.Icon = "icon16/fire.png"
TYPE.Color = color_white

TYPE.Order = 5

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_BURN

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_BURN + DMG_SLOWBURN + DMG_PLASMA

MCS1.RegisterType(TYPE)