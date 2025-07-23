local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.damage.example.name
-- augment prefix -> mcs.damage.example.augment

-- generic elements

TYPE.Set = "damage"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/page_white.png"
TYPE.Color = color_white

-- damage-specific elements
-- all of these are optional

-- determines position on the radar graphs
TYPE.Order = 0

-- prevent this damage type from showing up anywhere
TYPE.Hidden = true

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_POISON

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_POISON + DMG_CRUSH

-- generic damage only applies when damage has *no* other type
TYPE.Generic = true

MCS1.RegisterType(TYPE)