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

TYPE.BaseTime = 5 -- the time passed before 1 stack expires, in seconds (infinite if not included)
TYPE.MaxStacks = 4000000000 -- max stacks that can be applied at once
TYPE.InflictChance = 0.5 -- base chance to apply per hit, if this isn't here this effect cannot apply on hit
TYPE.Burst = 1 -- how many stacks to apply if the chance succeeds
TYPE.Reducible = true -- whether a hit with multiple damage types reduces this effect's apply chance
TYPE.InflictSound = "" -- sound when the effect is applied
TYPE.FullStackTimer = false -- whether a depleted stack timer destroys the entire effect instead of 1 stack
TYPE.NoTimerResets = false -- prevents the decay timer from resetting in any situation

TYPE.DamageTypes = {
	["example"] = true
}
TYPE.DamageTypeBlacklist = {
	["example"] = true
}
TYPE.HealthTypes = {
	["example"] = true
}
TYPE.HealthTypeBlacklist = {
	["example"] = true
}

-- hooks (self = entity this typeset is applied to)
-- effects always include stack count as the first argument

function TYPE:EffectFirstApplied(count)
	--
end

function TYPE:EffectApplied(count, amount)
	--
end

function TYPE:OnEffectProc(count)
	--
end

function TYPE:EffectExpired(count)
	--
end

MCS.RegisterType(TYPE)