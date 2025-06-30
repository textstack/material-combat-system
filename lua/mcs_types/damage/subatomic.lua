local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "subatomic"
TYPE.ServerName = "Subatomic" -- the server doesn't have access to localization
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = Color(255, 93, 255)

TYPE.Order = 3

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_DISSOLVE

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_ENERGYBEAM + DMG_RADIATION + DMG_PHYSGUN + DMG_DISSOLVE

MCS.RegisterType(TYPE)