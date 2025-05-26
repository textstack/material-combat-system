local TYPE = {}

TYPE.DoNotLoad = true

-- localization entries

-- name key -> mcs.effect.example.name

-- generic elements

TYPE.Set = "effect"
TYPE.ID = "example"
TYPE.ServerName = "Example" -- the server doesn't have access to localization
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

-- effect-specific elements
-- all of these are optional

TYPE.BaseTime = 5 -- the time passed before 1 stack expires
TYPE.InflictChance = 0.5 -- base chance to apply per hit, if this isn't here this effect cannot apply on hit
TYPE.Burst = 1 -- how many stacks to apply if the chance succeeds
TYPE.Reducible = true -- whether a hit with multiple damage types reduces this effect's inflict chance
TYPE.InflictSound = ""

TYPE.DamageTypes = {
	["example"] = true
}
TYPE.DamageTypeBlacklist = {
	["example"] = true
}
TYPE.HealthTypes = {
	["example"] = true
}
TYPE.DamageTypeBlacklist = {
	["example"] = true
}

-- hooks (self = player this typeset is applied to)
-- effects always include stack count as the first argument

function TYPE:EffectFirstApplied()
	self:Kill()
end

function TYPE:EffectExpired()
	self:Kill()
end

MCS.RegisterType(TYPE)