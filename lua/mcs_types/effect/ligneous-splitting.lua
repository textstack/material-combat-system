local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "ligneous-splitting"
TYPE.ServerName = "Effect Guarantee"
TYPE.Icon = "icon16/cut_red.png"
TYPE.Color = color_white

TYPE.BaseTime = 10
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.25
TYPE.FullStackTimer = true
TYPE.NoTimerResets = true
TYPE.Reducible = true
TYPE.InflictSound = "physics/wood/wood_strain4.wav"

TYPE.DamageTypes = {
	["splitting"] = true
}
TYPE.HealthTypes = {
	["ligneous"] = true
}

function TYPE:OnApplyEffect(_, effectType)
	if effectType.ID == "ligneous-splitting" then return true end
end

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

MCS1.RegisterType(TYPE)
