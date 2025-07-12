local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "effect"
TYPE.ID = "mechanical-subatomic"
TYPE.ServerName = "Interference"
TYPE.Icon = "icon16/transmit_error.png"
TYPE.Color = Color(255, 93, 255)

TYPE.BaseTime = 5
TYPE.InflictChance = 0.25
TYPE.Reducible = true
TYPE.InflictSound = "npc/scanner/scanner_electric2.wav"

TYPE.DamageTypes = {
	["subatomic"] = true
}
TYPE.HealthTypes = {
	["mechanical"] = true
}

function TYPE:DrawOverlay(count)
	local alpha = math.min(math.log(count + 1) * 50, 128)

	surface.SetDrawColor(0, 0, 0, alpha * 1.5)
	surface.DrawRect(0, 0, ScrW(), ScrH())

	surface.SetDrawColor(255, 255, 255, alpha)

	for i = 1, math.min(math.log(count + 1) * 1000, 10000) do
		local x = math.random(0, ScrW())
		local y = math.random(0, ScrH())
		local s = math.random(1, 5)

		surface.DrawRect(x, y, s, s)
	end
end

MCS.RegisterType(TYPE)
