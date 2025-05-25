local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.damage.example.name

-- generic elements

TYPE.Set = "damage"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- damage-specific elements

TYPE.GameDamage = {
	[DMG_GENERIC] = true
}

MCS.RegisterType(TYPE)