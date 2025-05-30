local TYPE = {}

TYPE.Set = "effect"
TYPE.ID = "mechanical-subatomic"
TYPE.ServerName = "Example"
TYPE.Icon = "icon16/star.png"
TYPE.Color = color_white

TYPE.BaseTime = 5
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "physics/flesh/flesh_strider_impact_bullet1.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:DrawOverlay(count)
	surface.SetMaterial("effects/tvscreen_noise003a")
	surface.SetDrawColor(255, 255, 255, math.log(count + 1) * 20)

	surface.drawTexturedRect(0, 0, ScrW(), ScrH())
end

MCS.RegisterType(TYPE)