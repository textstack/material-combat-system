local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-kinetic"
TYPE.ServerName = "Knocking"
TYPE.Icon = "icon16/asterisk_orange.png"
TYPE.Color = Color(255,255,255)

TYPE.BaseTime = 0.25
TYPE.MaxStacks = 1
TYPE.InflictChance = 0.75
TYPE.Reducible = true
TYPE.InflictSound = "physics/metal/metal_sheet_impact_hard7.wav"

TYPE.DamageTypes = {
	["kinetic"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:EffectInstantDamage(count, dmg)
	if not IsValid(dmg) then return end
	local dmgAmt = dmg:GetDamage()

	timer.Simple(0.5, function()
		if not IsValid(self) then return end

		local newDmg = DamageInfo()
		newDmg:SetDamage(dmgAmt * count * 0.1)
		newDmg:SetDamageType(DMG_SONIC)

		self:TakeDamageInfo(newDmg)
	end)
end

MCS.RegisterType(TYPE)
