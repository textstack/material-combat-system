local TYPE = {}

-- localization entries

-- name key -> mcs.damage.example.name
-- augment prefix -> mcs.damage.example.augment

-- generic elements

TYPE.Set = "damage"
TYPE.ID = "chemical"
TYPE.ServerName = "Chemical" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- damage-specific elements
-- all of these are optional

-- prevent this damage type from showing up anywhere
TYPE.Hidden = false

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_NERVEGAS

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_DROWN + DMG_PARALYZE + DMG_NERVEGAS + DMG_POISON + DMG_DROWNRECOVER + DMG_ACID

MCS.RegisterType(TYPE)