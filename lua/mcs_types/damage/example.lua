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

-- prevent this damage type from showing up anywhere
TYPE.Hidden = true

-- if not included, this damage type will do nothing
TYPE.GameDamage = DMG_GENERIC + DMG_POISON

MCS.RegisterType(TYPE)