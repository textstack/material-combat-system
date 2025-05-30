local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "ligneous-splitting"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.25
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:OnTakeDamage(_, dmg)
	self.MCS_StatusGuarantee = true
	timer.Simple(0, function()
		if IsValid(self) then
			self:MCS_RemoveEffect("ligneous-splitting")
		end
	end)
end

function TYPE:EffectExpired(_, force)
	self.MCS_StatusGuarantee = nil
end

MCS.RegisterType(TYPE)