local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.damage.example.name
-- augment prefix -> mcs.damage.example.augment

-- generic elements

TYPE.Set = "damage"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- damage-specific elements
-- all of these are optional

-- prevent this damage type from showing up anywhere
TYPE.Hidden = true

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_POISON + DMG_CRUSH

-- generic damage only applies when damage has *no* other type
TYPE.Generic = true

MCS.RegisterType(TYPE)