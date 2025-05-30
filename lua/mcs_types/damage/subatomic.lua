local TYPE = {}

TYPE.Set = "damage"
TYPE.ID = "subatomic"
TYPE.ServerName = "Subatomic" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_DISSOLVE

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_ENERGYBEAM + DMG_RADIATION + DMG_PHYSGUN + DMG_DISSOLVE

MCS.RegisterType(TYPE)