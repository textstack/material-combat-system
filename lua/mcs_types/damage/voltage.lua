local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "voltage"
TYPE.ServerName = "Voltage" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_SHOCK

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_SHOCK

MCS.RegisterType(TYPE)