local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "damage"
TYPE.ID = "penetrating"
TYPE.ServerName = "Penetrating" -- the server doesn't have access to localization
TYPE.Icon = "icon16/shield_delete.png"
TYPE.Color = color_white

TYPE.Order = 2

-- the damage type(s) applied for weapon augments, remove to not be able to augment
TYPE.AugmentDamage = DMG_AIRBOAT

-- the game damage types that this type maps to
TYPE.GameDamage = DMG_GENERIC + DMG_BULLET + DMG_AIRBOAT + DMG_SNIPER + DMG_PREVENT_PHYSICS_FORCE + DMG_NEVERGIB + DMG_ALWAYSGIB + DMG_REMOVENORAGDOLL + DMG_DIRECT + DMG_MISSILEDEFENSE

MCS1.RegisterType(TYPE)