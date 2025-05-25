local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.status.example.name

-- generic elements

TYPE.Set = "status"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- status-specific elements

TYPE.InflictChance = 0.5
TYPE.InflictSound = ""
TYPE.DamageTypes = {
	["example"] = true
}

-- hooks (self = player this typeset is applied to)
-- status effects always include stack count as the first argument

function TYPE:OnTakeDamage(count, dmg)
	self:Kill()
end

MCS.RegisterType(TYPE)