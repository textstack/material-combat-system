local TYPE = {}

-- localization entries

-- name key -> mcs.damage.example.name
-- augment prefix -> mcs.damage.example.augment

-- generic elements

TYPE.Set = "damage"
TYPE.ID = "kinetic"
TYPE.ServerName = "Kinetic" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- damage-specific elements
-- all of these are optional

-- prevent this damage type from showing up anywhere
TYPE.Hidden = false

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_SONIC

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_CRUSH + DMG_VEHICLE + DMG_FALL + DMG_BLAST + DMG_CLUB + DMG_SONIC + DMG_BLAST_SURFACE

-- generic damage only applies when damage has *no* other type
TYPE.Generic = true

MCS.RegisterType(TYPE)